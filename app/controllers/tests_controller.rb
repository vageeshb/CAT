class TestsController < ApplicationController
	before_action :load_test_suite, except: :exec_test_step
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
			wants.js { render 'show.js.erb'  }
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
				wants.js { render 'test_suites/show.js.erb' }
			end
		else
			respond_to do |wants|
				wants.html { }
				wants.js { render 'new.js.erb' }
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
	        format.js { render 'test_suites/show.js.erb'}
	      else
	        format.html {  }
	        format.js {  }
	      end
	    end
  	end
	def destroy
		@test = @test_suite.tests.find(params[:id]).delete
			@tests=@test_suite.tests.all.to_a
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
					wants.js { render 'index.js.erb' }
				end
			end
	end
	def exec_test_step
		@test_step_id = params[:test_step_id]
		@user_id = current_user.id
		TestStepWorker.perform_async(@test_step_id,@user_id)
	    respond_to do |wants|
	       wants.html {  }
	       wants.js { render 'summary.js.erb' }
	    end
	end
	private
		def signed_in_user
	      redirect_to root_url, notice:"Please Sign In" unless signed_in?
	    end
		def load_test_suite
			@test_suite = TestSuite.find(params[:test_suite_id])
			@tests=@test_suite.tests.all.to_a
			@test_suites=TestSuite.all
		end
		def test_params
			params.require(:test).permit(:name, :description)
		end
end
