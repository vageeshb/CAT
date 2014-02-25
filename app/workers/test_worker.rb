class TestWorker 
	include Sidekiq::Worker
	include Selenium
	require 'eventmachine'
	require 'faye'

	# Importing all methods
	require_relative 'methods'
	

	# Sidekiq options
	sidekiq_options :retry => false
	Sidekiq.configure_server do |config|
		database_url = ENV['DATABASE_URL']
		if database_url
			ENV['DATABASE_URL'] = "#{database_url}?pool=25"
			ActiveRecord::Base.establish_connection
		end
	end

	########################################

	# This method performs the test execution asynchronously
	def perform(job_id)
		
		job = Job.find(job_id)

		test = Test.find(job.test_id)
		
		user = User.find(job.user_id)
		
		param_url = SeleniumConfig.find_by_user_id(user.id).url.to_sym
		
		job.update_attributes(start_time: DateTime.now)

		run_status = execute_test(job.id,user,param_url,test)

		logger.info("\nFinal Status: " + run_status.to_s)
		
		job.update_attributes(status: 'Finished',finish_time: DateTime.now)

		#test.update_attributes(status: run_status, last_run: DateTime.now)
		
		EM.run {
			client = Faye::Client.new('http://192.168.10.54:9292/faye')
			publication = client.publish("/users/#{user.id}", "
				$('#notification').replaceWith('<a id=\"notification\" href=\"#\" data-toggle=\"tooltip\" title=\"Job Completed\"><i class=\"icon-globe\"></i></a>');
				$('#notification').css(\"background-color\", \"#8A0707\");
				$('#status').replaceWith('<a id=\"status\" href=\"#\" data-toggle=\"tooltip\" title=\"No Jobs in Progress\"><i class=\"icon-bell\"></i></a>');
				$('#job_#{job.id}').remove();
				")

			publication.callback do
				logger.info("Message sent to channel '/users/#{user.id}'")
			end

			publication.errback do |error|
				logger.info('There was a problem: ' + error.message)
			end
		}
		
	end
	########################################

	# This method performs the selenium test execution
	def execute_test(job_id,user,url,test)

		method = Methods.new
		
		logger.info("Inside execute test")
		
		port = 4444
		
		method.initialize_driver(url, port)
		
		test_steps = TestStep.where(test_id: test.id)
		
		log=""
		
		run_status=""

		report_name = DateTime.now.strftime('%d%m%y_%H%M%S')
		Report.create(name: report_name, job_id: job_id, user_id: user.id, description: "Execution of #{test.name} started")
		test_steps.each do |ts|
			if ts.element_id
				web_element = WebElement.find(ts.element_id)
				log, run_status = method.execute_test_step(web_element,ts.function,ts.value)
				logger.info("\nTest Step: '" + ts.step_name.to_s + "' : " + run_status.to_s)
			else
				log, run_status = method.assert(ts.expected)
				logger.info("\nTest Step: '" + ts.step_name.to_s + "' : " + run_status.to_s)
			end
			Report.create(name: report_name, job_id: job_id, user_id: user.id, description: "#{ts.step_name.to_s}", status: run_status.to_s)
			if run_status=="Fail" then
				method.tk_screenshot("./public/errors/#{user.email}/#{job_id}_error.png")
				logger.info("Fail Message: #{log}")
			end
			#ts.update_attributes(status: run_status, last_run: DateTime.now)
		end
		
		method.close
		Report.create(name: report_name, job_id: job_id, user_id: user.id, description: "Execution of #{test.name} completed")
		return run_status
	end
	########################################

end