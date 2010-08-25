class NotificationsController < ApplicationController
  respond_to :html, :xml, :json
  
  before_filter :load_application_by_api_key, :only => [:new, :create, :destroy]
  
  # GET /notifications
  # GET /notifications.xml
  # GET /notifications.json
  def index
    respond_with @notifications = Notification.all
  end

  # GET /notifications/1
  # GET /notifications/1.xml
  # GET /notifications/1.json
  def show
    respond_with @notification = Notification.find(params[:id])
  end

  # GET /notifications/new
  # GET /notifications/new.xml
  # GET /notifications/new.json
  def new
    respond_with @notification = @application.notifications.new
  end

  # POST /notifications
  # POST /notifications.xml
  # POST /notifications.json
  def create
    @notification = Notification.new(params[:notification])
    @notification.application = @application
    @notification.save

    respond_with @notification
  end

  # DELETE /notifications/1
  # DELETE /notifications/1.xml
  # DELETE /notifications/1.json
  def destroy
    @notification = @application.notifications.find(params[:id])
    @notification.destroy

    respond_with @notification
  end
  
  private
  
  def load_application_by_api_key
    @application = Application.where(:api_key => params[:api_key]).first
  end
end
