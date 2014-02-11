class TestStepWorker
	include Sidekiq::Worker
	include Selenium
	require 'eventmachine'
	require 'faye'

	# Importing all methods
	require_relative 'methods'
	

	# Sidekiq options
	sidekiq_options retry: false
	Sidekiq.configure_server do |config|
		database_url = ENV['DATABASE_URL']
		if database_url
			ENV['DATABASE_URL'] = "#{database_url}?pool=25"
			ActiveRecord::Base.establish_connection
		end
	end
	########################################

	# This method performs the test step execution asynchronously
	def perform(test_step_id, user_id)

		method = Methods.new

		test_step = TestStep.find(test_step_id)
		user = User.find(user_id)

		logger.info("\nStarting Test Step")
	
		param_url = SeleniumConfig.find_by_user_id(user.id).url.to_sym

		method.initialize_driver(param_url)

		if test_step.element_id 
			web_element = WebElement.find(test_step.element_id)
			log, run_status = method.execute_test_step(web_element,test_step.function,test_step.value)
		else
			log, run_status = method.assert(test_step.expected)
		end
		
		logger.info("\nFinal result: " + run_status)

		method.close

		test_step.update_attributes(status: run_status, last_run: DateTime.now)

		execution = ExecProgress.where(user_id: user.id, test_step_id: test_step.id).first

		if execution.queue_id

			QueueCart.delete(execution.queue_id)

			qid = execution.queue_id

			ExecProgress.delete(execution.id)

			EM.run {
				client = Faye::Client.new('http://192.168.10.54:9292/faye')
				publication = client.publish("/users/#{user.id}", "
					$('#notification').replaceWith('<a id=\"notification\" href=\"#\" data-toggle=\"tooltip\" title=\"Job Completed\"><i class=\"icon-globe\"></i></a>');
					$('#notification').css(\"background-color\", \"#8A0707\");
					$('#status').replaceWith('<a id=\"status\" href=\"#\" data-toggle=\"tooltip\" title=\"No Jobs in Progress\"><i class=\"icon-bell\"></i></a>');
					$('#q_row_#{qid}').remove();
				")

				publication.callback do
					logger.info("Message sent to channel '/users/#{user.id}'")
				end

				publication.errback do |error|
					logger.info('There was a problem: ' + error.message)
				end
			}
		else

			ExecProgress.delete(execution.id)

			EM.run {
				client = Faye::Client.new('http://192.168.10.54:9292/faye')
				publication = client.publish("/users/#{user.id}", "
					$('#notification').replaceWith('<a id=\"notification\" href=\"#\" data-toggle=\"tooltip\" title=\"Job Completed\"><i class=\"icon-globe\"></i></a>');
					$('#notification').css(\"background-color\", \"#8A0707\");
					$('#status').replaceWith('<a id=\"status\" href=\"#\" data-toggle=\"tooltip\" title=\"No Jobs in Progress\"><i class=\"icon-bell\"></i></a>');
					$(\'#exec_st_#{test_step.id}\').replaceWith(\'<a id=\"exec_st_#{test_step.id}\" href=\"/exec_test_step?test_step_id=#{test_step.id}\" data-remote=\"true\" class=\"btn btn-small icon-wrench\"></a>\');
				")

				publication.callback do
					logger.info("Message sent to channel '/users/#{user.id}'")
				end

				publication.errback do |error|
					logger.info('There was a problem: ' + error.message)
				end
			}

		end

	end
	########################################
end