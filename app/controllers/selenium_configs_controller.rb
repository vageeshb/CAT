class SeleniumConfigsController < ApplicationController
  before_action :set_selenium_config, only: [:show, :edit, :update, :destroy]
  before_action :signed_in_user

  # GET /selenium_configs/new
  def new
    if SeleniumConfig.find_by_user_id(current_user.id).nil?
      @selenium_config=SeleniumConfig.new
    else
      @selenium_config=SeleniumConfig.find_by_user_id(current_user.id)
    end
  end

  # GET /selenium_configs/1/edit
  def edit
  end

  # POST /selenium_configs
  # POST /selenium_configs.json
  def create
    @selenium_config = SeleniumConfig.new(selenium_config_params)

    respond_to do |format|
      if @selenium_config.save
        flash.now[:success]="Configuration Saved!"
        format.html {}
        format.js { render 'index.js.haml' }
      else
        format.html {  }
        format.js { render 'new.js.haml' }
      end
    end
  end

  # PATCH/PUT /selenium_configs/1
  # PATCH/PUT /selenium_configs/1.json
  def update
    respond_to do |format|
      if @selenium_config.update(selenium_config_params)
        flash.now[:success]="Configuration updated successfully!"
        format.html {}
        format.js { render 'index.js.haml' }
      else
        format.html {}
        format.js { render 'new.js.haml'  }
      end
    end
  end

  private
    def signed_in_user
        redirect_to root_url, notice:"Please Sign In" unless signed_in?
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_selenium_config
      @selenium_config = SeleniumConfig.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def selenium_config_params
      params.require(:selenium_config).permit(:browser, :url, :user_id)
    end
end
