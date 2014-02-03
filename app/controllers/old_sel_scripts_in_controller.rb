	LOGIN_REPORT_PATH = 'C:\seleniumscripts\APA\public\reports\login_ts'
	MESSAGES_REPORT_PATH = 'C:\seleniumscripts\APA\public\reports\message_ts'
	def index
	    @lts_td_count=LoginTestData.count
  	end

	def lts_show
	    @log_report_name=DateTime.now.strftime("%Y%m%d%H%M%S")+".html"
	    @td=LoginTestData.all
	    @result=Array.new
	    @td.each do |data|
	      # Passing test data to login function
	      @result<< login(data.email,data.password,data.check)
	    end
	    # Creating log file
	    log_file("#{LOGIN_REPORT_PATH}\\#{@log_report_name}",@result)
	    render 'lts_summary'
	end

	def mts_msg_fetch_show
	    @log_report_name=DateTime.now.strftime("%Y%m%d%H%M%S")+".html"
	    @td=LoginTestData.find_by check: true
	    @result=Array.new
	    # Passing test data to login function
	    @result=messages_fetch(@td.email,@td.password)
	    
	    # Creating log file
	    log_file("#{MESSAGES_REPORT_PATH}\\#{@log_report_name}",@result)
	    render 'mts_summary'
	end

  private
    # Function to create log files
    def log_file(file_name,result)
      File.open(file_name, 'w+') do |f|
        f.puts "<h3>Created at #{DateTime.now.strftime("%Y%m%d%H%M%S")}</h3>
          <table class=\"table table-bordered table-hover\">
            <th colspan=\"3\"> Test Suite
            </th>
            <tr>
              <td>S.No</td>
              <td>Test Case No</td>
              <td>Status</td>
            </tr>"
            cnt=0
            result.each do |res|
            	if (res.include? "Pass")==true then
            		f.puts "<tr class=\"success\">"
            	else
            		f.puts "<tr class=\"error\">"
            	end
              	f.puts "<td> #{cnt+=1}</td><td>TC00#{cnt}</td><td>#{res}</td></tr>"
            end
            f.puts "</table>"
      end
    end

  	# Functions for fetching
    def fByid(element,query)
      return element.find_element(:id,query)
    end

    def fByxpath(element,query)
      return element.find_element(:xpath,query)
    end


    def fByname(element,query)
      return element.find_element(:name,query)
    end

    # Login Suite
    # Testing Login Functionality with Valid/Invalid Credentials
    def login(email, password, check)

      driver = Selenium::WebDriver.for :firefox
      wait = Selenium::WebDriver::Wait.new(timeout:10)

      # Accessing base site
      driver.get 'http://www.ourgoalplan.com'

      user_name_element=fByname(driver,"txtName")
      password_element=fByname(driver,"txtPassword")
      
      # Testing for element presence
      wait.until {
          user_name_element.displayed?
      }
      wait.until {
          password_element.displayed?
      }

      # Attempting login
      user_name_element.send_keys(email)
      password_element.send_keys(password)
      user_name_element.send_keys :return
      
      if check==true then
       wait.until {fByxpath(driver,"/html/body/form/table/tbody/tr/td/img").displayed?}
        if driver.page_source.include? email
          driver.quit
          return "Pass: Correct Credentials" 
        else
          driver.quit
          return "Fail: Correct Credentials" 
        end
      else
        wait.until {fByname(driver,"txtName").displayed?}
        if /Invalid/.match(driver.page_source)
          driver.quit
          return "Pass: Incorrect Credentials" 
        else
          driver.quit
          return "Fail: Incorrect Credentials"  
        end
      end 

      driver.quit
    end

    # Message Suite
    # Fetching all the messages
    def messages_fetch(username,password)
		begin
			driver = Selenium::WebDriver.for :firefox
			wait = Selenium::WebDriver::Wait.new(timeout:10)
			# Accessing base site
			driver.get 'http://www.ourgoalplan.com'
			main_window = driver.window_handle

			user_name_element=fByname(driver,"txtName")
			password_element=fByname(driver,"txtPassword")
			
			# Testing for login element presence
			wait.until {
			   	user_name_element.displayed?
			}
			wait.until {
		    	password_element.displayed?
			}

			# Attempting login
			user_name_element.send_keys(username)
			password_element.send_keys(password)
			user_name_element.send_keys :return

			wait.until {fByxpath(driver,'//*[@id="ucGPSMenu_hlnkMessage"]').displayed?}

			msg_link=fByxpath(driver,'//*[@id="ucGPSMenu_hlnkMessage"]')
			
			msg_link.send_keys :return

			wait.until {fByxpath(driver,'/html/body/form/div[5]/div[2]/div/div[2]/div/div/table/tbody/tr[2]/td').displayed?}
			cell_text=fByxpath(driver,'/html/body/form/div[5]/div[2]/div/div[2]/div/div/table/tbody/tr[2]/td').text
			
			# Fetching all the messages
			@i=1
			@result_set=[]
		  	while cell_text do
		    	@i+=1
				if fByxpath(driver,'/html/body/form/div[5]/div[2]/div/div[2]/div/div/table/tbody/tr['+"#{@i}"+']/td').displayed? then
					@result_set << fByxpath(driver,'/html/body/form/div[5]/div[2]/div/div[2]/div/div/table/tbody/tr['+"#{@i}"+']/td').text	
				end  
			end	
	  	rescue  
	    	false
		end
		driver.quit
		return @result_set
	end