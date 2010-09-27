class Graph < ActiveRecord::Base
  belongs_to :collection
  has_many :edges
  has_many :graph_points
  def self.resolve_chart_settings(title)
    universals = ", height: 515, width:920, is3D: true"
    case title
    when "geographic_placement"
      return "GeoMap", "region: 'world', colors: [0xFF8747, 0xFFB581, 0xc06000], dataMode: 'markers', showLegend: false" + universals
    when "tag_distribution"
      return "Table", "pieMinimalAngle: 1, title: 'Tag Distribution', height: 500, width:920, is3D: true"
    when "time_distribution"
      return "LineChart", "title: 'Photograph Capture Times', titleX: 'Date Photograph Taken', titleY: 'Number of Photographs Taken'" + universals
    when "views_distribution"
      return "LineChart", "title: 'Number of Views', titleX: 'Date Photograph Taken', titleY: 'Number of Views'" + universals
    end
  end
  
  def self.to_google_graph(dataset, tqx)
    viz = "google.visualization.Query.setResponse({version:0.1,status:'ok',#{tqx},table:{cols:"
    viz+="["
    dataset["headers"].each do |d|
      viz+="{id:\"#{d}\",label:\"#{d}\",type:'#{Graph.google_class(dataset["dataset"].first[d].class)}'},"
    end
    viz = viz.chop+"],rows:["
    dataset["dataset"].each do |d| 
      viz+="{c:["
      dataset["headers"].each do |header|
        if d[header].class == String
          viz+="{v:\"#{d[header]}\"},"
        else
          viz+="{v:#{d[header]}},"
        end
      end
      viz=viz.chop+"]},"
    end
    viz+="]}})"
  end
  
  def self.google_class(class_type)
    case class_type.to_s
    when "String"
      return "string"
    when "Fixnum"
      return "number"
    when "Float"
      return "number"
    end
  end
  
end
