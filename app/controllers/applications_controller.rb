class ApplicationsController < ApplicationController
  
  respond_to :html, :xml, :json
  
  # GET /applications
  # GET /applications.xml
  # GET /applications.json
  def index
    respond_with @applications = Application.all
  end

  # GET /applications/1
  # GET /applications/1.xml
  def show
    respond_with @application = Application.find(params[:id])
  end

  # GET /applications/new
  # GET /applications/new.xml
  def new
    respond_with @application = Application.new
  end

  # GET /applications/1/edit
  def edit
    respond_with @application = Application.find(params[:id])
  end

  # POST /applications
  # POST /applications.xml
  def create
    @application = Application.create(params[:application])

    unless @application.new_record?
      flash[:notice] = 'Application was successfully created.'
    end

    respond_with @application
  end

  # PUT /applications/1
  # PUT /applications/1.xml
  def update
    @application = Application.find(params[:id])

    if @application.update_attributes(params[:application])
      flash[:notice] = 'Application was successfully updated.'
    end
    
    respond_with @application
  end

  # DELETE /applications/1
  # DELETE /applications/1.xml
  def destroy
    @application = Application.find(params[:id])
    @application.destroy

    respond_with @application
  end
end
