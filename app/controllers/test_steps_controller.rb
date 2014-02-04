class TestStepsController < ApplicationController
	before_action :load_test, except: [:update_pages, :update_elements, :update_function]
	before_action :signed_in_user
	def new
		@test = @test_suite.tests.find(params[:test_id])
		@test_step = @test.test_steps.new
		
		respond_to do |wants|
			wants.html {  }
			wants.js {}
		end
	end
	def show
		@test_step=@test.test_steps.find(params[:id])
		respond_to do |wants|
			wants.html {  }
			wants.js {}
		end
	end
	def create
		@test_step = @test.test_steps.new(test_step_params)
		if @test_step.save
			@test_steps=@test.test_steps.all.to_a
			flash.now[:success]="Test Step: \'#{@test_step.step_name}\' successfully created!"
			respond_to do |wants|
				wants.html { }
				wants.js { render 'tests/show.js.haml'}
			end
		else
			
			respond_to do |wants|
				wants.html { }
				wants.js { render 'new.js.haml' }
			end
			
		end
	end
	def edit
		@test_step = @test.test_steps.find(params[:id])
	    respond_to do |format|
	      format.js { }
	    end
  	end
	def update
		@test_step = @test.test_steps.find(params[:id])
	    respond_to do |format|
	      	if @test_step.update(test_step_params)
	      		@test_steps=@test.test_steps.all.to_a
		        flash.now[:success] = "Test Step \'#{@test_step.step_name}\' was successfully updated."
		        format.html { }
		        format.js { render 'tests/show.js.haml'}
			else
		        format.html { render action: 'edit' }
		        format.js {  }
	     	end
	    end
  	end
	def destroy
		@test_step = @test.test_steps.find(params[:id])
		if @test_step.destroy
			
			flash.now[:success]="Test Step: \'#{@test_step.step_name}\' successfully deleted!"
			respond_to do |wants|
				wants.html {  }
				wants.js {}
			end
		end
	end
	def update_pages
		@or=params[:or_id]
		@pages={}
		@pages["Select a Page"]=""
		@web_elements=WebElement.where(object_repository_id: @or)
		@web_elements.each {|e| @pages[e.page_name] = e.page_name }
	end
	def update_elements
		@or=params[:or_id]
		@pg=params[:pg_name]
		@elements={}
		@elements["Select an Element"]=""
		@web_elements=WebElement.where(object_repository_id: @or, page_name: @pg)
		@web_elements.each {|e| @elements[e.element_name] = e.id }
	end
	def update_function
		@or=params[:or_id]
		@pg=params[:pg_name]
		@el=params[:el_name]
		@functions={}
		@functions["Select a Function"]=""
		@web_element=WebElement.where(object_repository_id: @or,element_name:@el, page_name:@pg).first
		case @web_element.element_type
			when 'Text Box'
				@functions["Enter Value"]="Enter Value"
			when 'Select Box'
				@functions["Click"]="Click"
			when 'Option Box'
				@functions["Select Option"]="Select Option"
			when 'Link'
				@functions["Click"]="Click"
			when 'Button'
				@functions["Click"]="Click"
		end
	end
	private
		def signed_in_user
	      redirect_to root_url, notice:"Please Sign In" unless signed_in?
	    end
		def load_test
			@test = Test.find(params[:test_id])
			@test_suite = @test.test_suite
			@or_options={}
			ObjectRepository.all.each {|o| @or_options[o.name] = o.id}
		end
		def test_step_params
			params.require(:test_step).permit(:step_name, :step_description, :expected, :object_repository_id, :page_name, :element_id, :value, :function)
		end
end
