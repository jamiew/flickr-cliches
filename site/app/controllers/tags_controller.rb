class TagsController < ApplicationController
  layout "default"
  # GET /tags
  # GET /tags.xml
  def index
    @tags = Tag.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @tags }
    end
  end

  # GET /tags/1
  # GET /tags/1.xml
  def show
    @tag = Tag.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @tag }
    end
  end

  # GET /tags/new
  # GET /tags/new.xml
  def new
    @tag = Tag.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @tag }
    end
  end
  
  def new_tag_form
    respond_to do |format|
      format.js { render :partial => "/tags/new"}
    end
  end


  # GET /tags/1/edit
  def edit
    @tag = Tag.find(params[:id])
  end

  # POST /tags
  # POST /tags.xml
  def create
    debugger
    if Tag.find_by_term(params[:tag][:term]).class == Tag
      @tag = Tag.find_by_term(params[:tag][:term])
      @tag.photos << Photo.find(params[:tag][:photo_id])
    else
      @tag = Tag.new
      @tag.term = params[:tag][:term]
      @tag.slug = params[:tag][:term].downcase.gsub(" ", "-")
      @tag.human_coded = true
      @tag.save
      @tag.photos << Photo.find(params[:tag][:photo_id])
    end    
    respond_to do |format|
      flash[:notice] = 'Tag was successfully created.'
      format.html { redirect_to(request.referrer) }
      format.xml  { render :xml => @tag, :status => :created, :location => @tag }
      format.js { 
        render :update do |page|
          page.visual_effect :highlight, "tags"
        end
      }        
    end
  end

  # PUT /tags/1
  # PUT /tags/1.xml
  def update
    @tag = Tag.find(params[:id])

    respond_to do |format|
      if @tag.update_attributes(params[:tag])
        flash[:notice] = 'Tag was successfully updated.'
        format.html { redirect_to(@tag) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @tag.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /tags/1
  # DELETE /tags/1.xml
  def destroy
    @tag = Tag.find(params[:id])
    @tag.destroy

    respond_to do |format|
      format.html { redirect_to(tags_url) }
      format.xml  { head :ok }
    end
  end
  
  def generate_google_graph
    @tag = Tag.find(params[:id])
    case params[:graph_type]
    when "tag_distribution"
      data_set = {"dataset" => [], "headers" => ["Term", "Frequency"]}
      raw_data = {}
      (@tag.photos.collect{|t| t.tags}.flatten-[@tag]).sort{|x,y| x.slug<=>y.slug}.each do |tag|
        if raw_data[tag.term]
          raw_data[tag.term]+=1
        else
          raw_data[tag.term] = 1
        end
      end
      data_set["dataset"] = raw_data.collect{|x| {"Term" => x[0], "Frequency" => x[1]}}.sort{|y,x| x["Frequency"]<=>y["Frequency"]}
    when "time_distribution"
      data_set = {"dataset" => [], "headers" => ["label", "value"]}
      raw_data = {}
      data = @tag.photos.collect{|x| x.taken_at}.sort{|x,y| x.to_i<=>y.to_i}
      photos = []
      data.each do |x|
        datum = {}
        datum["label"] = x.strftime("%b %d, %Y, %H:%M:%S")
        datum["value"] = 1
        photos << datum
      end
      data_set["dataset"] = Pretty.time_generalize(photos)
    when "geographic_placement"
      data_set = {"dataset" => [], "headers" => ["Latitude", "Longitude", "Numeric Value", "Label"]}
      raw_data = {}
      @tag.photos.collect{|p| ["Lat/Lon:#{p.lat},#{p.lon}", p.lat, p.lon]}.each do |x|
        if raw_data[x[0]]
          raw_data[x[0]][0]+=1
        else
          raw_data[x[0]] = [1, x[1],x[2]]
        end
      end
      data_set["dataset"] = raw_data.collect{|x| {"Latitude" => x.last[1], "Longitude" => x.last[2], "Numeric Value" => x.last[0], "Label" => x.first}}
    when "views_distribution"
      data_set = {"dataset" => [], "headers" => ["label", "value"]}
      raw_data = {}
      data = @tag.photos.collect{|x| {"taken_at" => x.taken_at, "views" => x.views}}.sort{|x,y| x["taken_at"].to_i<=>y["taken_at"].to_i}
      photos = []
      data.each do |x|
        datum = {}
        datum["label"] = x["taken_at"].strftime("%b %d, %Y, %H:%M:%S")
        datum["value"] = x["views"]
        photos << datum
      end
      data_set["dataset"] = Pretty.time_generalize(photos)
    end
    respond_to do |format|
      format.json { render :json => Graph.to_google_graph(data_set, params[:tqx]) }
    end        
  end
    
  def render_google_graph
    chart_type, chart_options = Graph.resolve_chart_settings(params[:graph_type])
    if request.xhr?
      render :update do |page|
        page.replace_html 'dataDisplay', :partial => "/tags/graph", :locals => {
            :title => params[:graph_type],
            :chart_type => chart_type,
            :chart_options => chart_options,
            :graph_id => params[:id],
        }
      end
    end
  end
end
