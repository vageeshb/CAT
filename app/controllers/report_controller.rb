class ReportController < ApplicationController
  before_action :signed_in_user
  def index
  	respond_to do |wants|
  		wants.html {  }
  		wants.js {  }
  	end
  end

  def view

  	@reports = Execution.where(user_id: current_user.id).group("name")
  	respond_to do |wants|
  		wants.html {  }
  		wants.js { }
  	end
  end

  def show
  	@executions = Execution.where(user_id: current_user.id, name: params[:name])
  	@steps = Array.new
  	@final_status = "Pass"
  	@executions.each do |e|
  		@steps.push TestStep.find(e.test_step_id)
  		if e.status == "Fail" then @final_status="Fail" end
  	end
  end

  private
  	def signed_in_user
  		redirect_to root_url, notice:"Please Sign In" unless signed_in?
  	end
end
