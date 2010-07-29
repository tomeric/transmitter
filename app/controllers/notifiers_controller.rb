class NotifiersController < ApplicationController
  
  before_filter :load_application

  # GET /notifiers/new
  # GET /notifiers/new.xml
  def new
    @notifier = @application.notifiers.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @notifier }
    end
  end

  # GET /notifiers/1/edit
  def edit
    @notifier = @application.notifiers.find(params[:id])
  end

  # POST /notifiers
  # POST /notifiers.xml
  def create
    @notifier = @application.notifiers.create(params[:notifier])

    respond_to do |format|
      if @notifier.valid?
        format.html { redirect_to(@application, :notice => 'Notifier was successfully created.') }
        format.xml  { render :xml => @notifier, :status => :created, :location => @notifier }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @notifier.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /notifiers/1
  # PUT /notifiers/1.xml
  def update
    @notifier = @application.notifiers.find(params[:id])

    respond_to do |format|
      if @notifier.update_attributes(params[:notifier])
        format.html { redirect_to(@application, :notice => 'Notifier was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @notifier.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /notifiers/1
  # DELETE /notifiers/1.xml
  def destroy
    @notifier = @application.notifiers.find(params[:id])
    @notifier.destroy

    respond_to do |format|
      format.html { redirect_to(@application) }
      format.xml  { head :ok }
    end
  end
  
  private
  
  def load_application
    @application = Application.find(params[:application_id])
  end
end
