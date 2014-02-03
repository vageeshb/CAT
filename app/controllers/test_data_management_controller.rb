class TestDataManagementController < ApplicationController
  def index
  	@login_td=LoginTestData.new
  end

  def create_login_td
  	@login_td=LoginTestData.create(post_params)
  	if @login_td.save then
  		flash[:success]="Login Test Data Created Successfully!"
  		redirect_to test_data_management_path
  	else
  		render 'index'
  	end
  end

  private
  	def post_params
      params.require(:login_test_data).permit(:email, :password, :check)
    end
end
