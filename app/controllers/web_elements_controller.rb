class WebElementsController < ApplicationController
	before_action :load_object_repository
  before_action :signed_in_user
  def new
  	@web_element=@object_repository.web_elements.new
	respond_to do |wants|
	  	wants.html {  }
	  	wants.js {  }
	end  	
  end
  def create
  	@web_element = @object_repository.web_elements.new(post_params)
  	respond_to do |wants|
  		if @web_element.save
  			flash.now[:success] = "Web Element was successfully created."
  			wants.html {  }
  			wants.js { render 'object_repositories/show' }
  		else
  			wants.html {  }
  			wants.js { render 'new' }
  		end
  	end
  end
  def edit
  	@web_element=@object_repository.web_elements.find(params[:id])
  	respond_to do |format|
      format.js { }
    end
  end
  def update
	@web_element=@object_repository.web_elements.find(params[:id])
    respond_to do |format|
      if @web_element.update(post_params)
        #@object_repositories=ObjectRepository.all
        flash.now[:success] = 'Web Element was successfully updated.'
        format.html {  }
        format.js { render 'object_repositories/show'}
      else
        format.html { }
        format.js {  }
      end
    end
  end
  def destroy
  	@web_element=@object_repository.web_elements.find(params[:id])
  	if  @web_element.destroy
  		flash.now[:success]="Web element \'#{@web_element.element_name}\' was deleted successfully."
  		respond_to do |wants|
  			wants.html {  }
  			wants.js {}
  		end
  	end
  end
  private
    def signed_in_user
      redirect_to root_url, notice:"Please Sign In" unless signed_in?
    end
  	def load_object_repository
  		@object_repository=ObjectRepository.find(params[:object_repository_id])
  		@web_elements = @object_repository.web_elements
  	end
  	def post_params
  		params.require(:web_element).permit(:page_name,:element_name,:element_type,:identifier_name,:identifier_value)
  	end
end