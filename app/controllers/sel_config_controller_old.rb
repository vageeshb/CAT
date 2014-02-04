class SelConfigController < ApplicationController
	before_action :signed_in_user
	
  	def index
  		@sel_config=SelConfig.find_by_user_id(current_user.id)
	end
	def show
	end
	def new
		if SelConfig.find_by_user_id(current_user.id).nil?
			@sel_config=SelConfig.new
		else
			@sel_config=SelConfig.find_by_user_id(current_user.id)
		end
	end
	def create
		if SeleniumConfig.find_by_user_id(current_user.id).nil?
			@sel_config=SelConfig.new
		else
			@sel_config=SelConfig.find_by_user_id(current_user.id)
		end
		@sel_config.update_attributes(new_config_params)
		if @sel_config.save
			@sel_config.update_attribute(:user_id,current_user.id)
			@sel_config.save
			flash.now[:success]="Configuration Saved!"
			respond_to do |format|
				format.js { render 'index.js.haml'}
			end
		else
			respond_to do |format|
				format.js { render 'new.js.haml'}
			end
		end
	end
	def edit
		@sel_config=SelConfig.find_by_user_id(current_user.id)
	end

	def update
		@sel_config=SelConfig.find_by_user_id(current_user.id)
	    respond_to do |format|
	      if @sel_config.update(new_config_params)
	        flash.now[:success] = 'Configuration was successfully updated.'
	        format.js { render 'index.js.haml'}
	      else
	        format.html { render action: 'edit' }
	        format.js { render 'fail_create.js.haml' }
	      end
    	end
  	end
	private
		def signed_in_user
	      redirect_to root_url, notice:"Please Sign In" unless signed_in?
	    end
		def new_config_params
			params.require(:sel_config).permit(:browser, :url, :user_id)
		end
end
