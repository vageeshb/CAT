class TestSuitesController < ApplicationController
  before_action :load_test_suite, except: :exec_test
  before_action :signed_in_user
  def new
    @test_suite = TestSuite.new
    respond_to do |wants|
      wants.html {  }
      wants.js { }
    end
  end
  def show
    @test_suite=TestSuite.find(params[:id])
    @tests=@test_suite.tests
    respond_to do |wants|
      wants.html {  }
      wants.js {}
    end
  end
  def index
    @test_suite=TestSuite.new
    @test_suites=TestSuite.where(:user_id => current_user.id).to_a
  end
  def create
    @test_suite=TestSuite.new(new_ts_params)
    if @test_suite.save then
      @test_suites=TestSuite.where(:user_id => current_user.id)
      flash.now[:success]="Test Suite #{@test_suite.name} created!"
      respond_to do |wants|
        wants.html { }
        wants.js { render 'index.js.haml'}
      end
    else
      respond_to do |wants|
        wants.html { }
        wants.js { render 'new.js.haml'}
      end
    end
  end
  def edit
    @test_suite = TestSuite.find(params[:id])
    respond_to do |wants|
      wants.html {  }
      wants.js {}
    end
  end
  def update
    @test_suite=TestSuite.find(params[:id])
    if @test_suite.update(new_ts_params)
      respond_to do |wants|
        flash.now[:success] = "Test Suite updated successfully."
        wants.html {  }
        wants.js { render 'index.js.haml'}
      end
    end
  end
  
  def destroy
    @test_suite=TestSuite.find(params[:id])
    if @test_suite.destroy
      flash.now[:success]="Test Suite \'#{@test_suite.name}\' successfully deleted!"
      if TestSuite.all.count==0
        flash.now[:notice]="There are no test suites!"
      end
      respond_to do |wants|
        wants.html {  }
        wants.js { }
      end
    end
  end

  def exec_test
    @test_id = params[:test_id]
    @user_id = current_user.id
    TestWorker.perform_async(@test_id, @user_id)
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
      @test_suites=TestSuite.where(:user_id => current_user.id).to_a
    end
    def new_ts_params
      params.require(:test_suite).permit(:name,:description, :user_id)
    end
end
