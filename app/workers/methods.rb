class Methods
	include Selenium

	# Initialising driver
	def initialize_driver(web_url)
		@driver = Selenium::WebDriver.for :firefox #:remote, url: "http://localhost:9134"
		@wait = Selenium::WebDriver::Wait.new(timeout:10)
		@driver.manage.window.maximize
		@driver.get "#{web_url}"
		
	end
	########################################

	# This method performs the selenium test
	def execute_test_step(web_element,function,value)
		begin
			log = ""
			
			case web_element.identifier_name
				when 'ID'
					e = find(:id => web_element.identifier_value)
				when 'CLASS'
					e = find(:class => web_element.identifier_value) 
				when 'CSS'
					e = find(:css => web_element.identifier_value) 
				when 'NAME'
					e = find(:name => web_element.identifier_value) 
				when 'XPATH'
					e = find(:xpath => web_element.identifier_value) 
			end
			if !e.nil? then
				log << ("\n'" + web_element.element_name.to_s + "' Presence: True")
				case function
					when 'Click'
						e.send_keys :return
						log << ("\nAction: Click")
					when 'Enter Value'
						e.send_keys(value)
						log << ("\nAction: Enter Value - #{value}")
				end
			else
				raise "\nCould not find element #{e.element_name}"
			end

			return log, "Pass"

		rescue Exception => e
			
			log << e.message
			return log, "Fail"
		end
	end

	def assert(expected)
		begin
			log = ""
			@wait.until { @driver.page_source.include? expected }
			if @driver.page_source.include? expected
				log << "\nAction: Assertion of #{expected} - True"
				run_status = "Pass"
			else
				log << "\nAction: Assertion of #{expected} - False"
				run_status = "Fail"
			end
			
			return log, run_status

		rescue Exception => e
			run_status = "Error"
			log << e.message
			return log, run_status
		end
	end

	def close
		@driver.quit
	end

	private
		def find hash
		    @wait.until { @driver.find_element hash }
		    @driver.find_element hash
		end

end