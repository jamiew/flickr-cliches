class FlickrConfigsController < ApplicationController
  # GET /flickr_configs
  # GET /flickr_configs.xml
  def index
    @flickr_configs = FlickrConfig.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @flickr_configs }
    end
  end

  # GET /flickr_configs/1
  # GET /flickr_configs/1.xml
  def show
    @flickr_config = FlickrConfig.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @flickr_config }
    end
  end

  # GET /flickr_configs/new
  # GET /flickr_configs/new.xml
  def new
    @flickr_config = FlickrConfig.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @flickr_config }
    end
  end

  # GET /flickr_configs/1/edit
  def edit
    @flickr_config = FlickrConfig.find(params[:id])
  end

  # POST /flickr_configs
  # POST /flickr_configs.xml
  def create
    @flickr_config = FlickrConfig.new(params[:flickr_config])

    respond_to do |format|
      if @flickr_config.save
        flash[:notice] = 'FlickrConfig was successfully created.'
        format.html { redirect_to(@flickr_config) }
        format.xml  { render :xml => @flickr_config, :status => :created, :location => @flickr_config }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @flickr_config.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /flickr_configs/1
  # PUT /flickr_configs/1.xml
  def update
    @flickr_config = FlickrConfig.find(params[:id])

    respond_to do |format|
      if @flickr_config.update_attributes(params[:flickr_config])
        flash[:notice] = 'FlickrConfig was successfully updated.'
        format.html { redirect_to(@flickr_config) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @flickr_config.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /flickr_configs/1
  # DELETE /flickr_configs/1.xml
  def destroy
    @flickr_config = FlickrConfig.find(params[:id])
    @flickr_config.destroy

    respond_to do |format|
      format.html { redirect_to(flickr_configs_url) }
      format.xml  { head :ok }
    end
  end
end
