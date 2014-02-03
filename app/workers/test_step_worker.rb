class TestStepWorker
	include Sidekiq::Worker
	include Selenium

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
 	end
	########################################
end