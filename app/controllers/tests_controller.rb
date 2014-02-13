class TestsController < ApplicationController
	before_action :load_test_suite, except: [:exec_test_step, :add_ts]
	before_action :signed_in_user

	def new
		@test = @test_suite.tests.new
		respond_to do |wants|
			wants.html {  }
			wants.js {}
		end
	end

	def show
		@test=@test_suite.tests.find(params[:id])
		@test_steps=@test.test_steps
		respond_to do |wants|
			wants.html {  }
			wants.js { render 'show.js.haml'  }
		end
	end

	def index
		if @test_suite.tests.size>0 then
			respond_to do |wants|
				wants.html {  }
				wants.js {}
			end
		else
			flash.now[:notice]="No Tests Found for #{@test_suite.name}"
			respond_to do |wants|
				wants.html {  }
				wants.js { }
			end
		end
	end

	def create
		@test = @test_suite.tests.new(test_params)
		if @test.save
			@tests=@test_suite.tests.all.to_a
			flash.now[:success]="Test Name: \'#{@test.name}\' successfully created!"
			respond_to do |wants|
				wants.html { }
				wants.js { render 'test_suites/show.js.haml' }
			end
		else
			respond_to do |wants|
				wants.html { }
				wants.js { render 'new.js.haml' }
			end
			
		end
	end

	def edit
		@test = @test_suite.tests.find(params[:id])
	    respond_to do |format|
	      format.js { }
	    end
  	end

	def update
		@test = @test_suite.tests.find(params[:id])
	    respond_to do |format|
	      if @test.update(test_params)
	      	@tests=@test_suite.tests.all.to_a
	        flash.now[:success] = "Test \'#{@test.name}\' was successfully updated."
	        format.html {  }
	        format.js { render 'test_suites/show.js.haml'}
	      else
	        format.html {  }
	        format.js {  }
	      end
	    end
  	end

	def destroy
		@test = @test_suite.tests.find(params[:id]).delete
		@tests = @test_suite.tests.all.to_a
		flash.now[:success] = "Test \'#{@test.name}\' was successfully deleted."
		if @test_suite.tests.size>0 then
			respond_to do |wants|
				wants.html {  }
				wants.js {  }
			end
		else
			flash.now[:notice]="No Tests Found for #{@test_suite.name}"
			respond_to do |wants|
				wants.html {  }
				wants.js { render 'index.js.haml' }
			end
		end
	end

	def add_ts
		@test_step = TestStep.find(params[:test_step_id])
		@test_id = @test_step.test_id
		@test_suite_id = Test.find(@test_id).test_suite_id
		@queue_ts = Job.new(user_id: current_user.id,test_suite_id: @test_suite_id, test_id: @test_id, test_step_id: @test_step.id, status: "Pending")
		respond_to do |wants|
			if @queue_ts.save
				flash.now[:success]="Test Step \'#{@test_step.step_name}\' added to Job queue!"
				wants.js {}
			else
				flash.now[:error]="There was some error. Test Step could not be added to the queue!"
				wants.js {}
			end
		end
	end

	def exec_test_step
		@test_step_id = params[:test_step_id]
		@user_id = current_user.id
		#@exec = ExecProgress.create(user_id: @user_id, test_step_id: @test_step_id, status: 'Start') 
		#TestStepWorker.perform_async(@test_step_id,@user_id)
	    respond_to do |wants|
	       wants.html {  }
	       wants.js { render 'summary.js.haml' }
	    end
	end
	private
		def signed_in_user
	      redirect_to root_url, notice:"Please Sign In" unless signed_in?
	    end
		def load_test_suite
			@test_suite = TestSuite.find(params[:test_suite_id])
			@tests = @test_suite.tests.all.to_a
			@test_suites = TestSuite.all
		end
		def test_params
			params.require(:test).permit(:name, :description)
		end
end
