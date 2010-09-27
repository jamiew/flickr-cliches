class GraphsController < ApplicationController
  layout 'default'
  def generate_google_graph
    @tag_category = TagCategory.find(params[:id])
    case params[:graph_type]
    when "tag_distribution"
      data_set = {"dataset" => [], "headers" => ["Term", "Frequency"]}
      raw_data = {}
      (@tag_category.photos.collect{|t| t.tags}.flatten-@tag_category.tags).sort{|x,y| x.slug<=>y.slug}.each do |tag|
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
      data = @tag_category.photos.collect{|x| x.taken_at}.sort{|x,y| x.to_i<=>y.to_i}
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
      @tag_category.photos.collect{|p| ["Lat/Lon:#{p.lat},#{p.lon}", p.lat, p.lon]}.each do |x|
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
      data = @tag_category.photos.collect{|x| {"taken_at" => x.taken_at, "views" => x.views}}.sort{|x,y| x["taken_at"].to_i<=>y["taken_at"].to_i}
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
        page.replace_html 'dataDisplay', :partial => "/tag_categories/graph", :locals => {
            :title => params[:graph_type],
            :chart_type => chart_type,
            :chart_options => chart_options,
            :graph_id => params[:id],
        }
      end
    end
  end
end
