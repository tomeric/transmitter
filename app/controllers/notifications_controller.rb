class NotificationsController < ApplicationController
  respond_to :html, :xml, :json
  
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
    respond_with @notification = Notification.new
  end

  # POST /notifications
  # POST /notifications.xml
  # POST /notifications.json
  def create
    respond_with @notification = Notification.create(params[:notification])
  end

  # DELETE /notifications/1
  # DELETE /notifications/1.xml
  # DELETE /notifications/1.json
  def destroy
    @notification = Notification.find(params[:id])
    @notification.destroy

    respond_with @notification
  end
end
