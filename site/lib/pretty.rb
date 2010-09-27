class Pretty
  def self.time_generalize(graphs)
    sorted_times = graphs.collect{|g| Time.parse(g["label"].to_s).to_i}.sort
    length = sorted_times.last-sorted_times.first
    if length < 60
      new_graphs = Pretty.time_rounder("second", graphs)
    elsif length < 3600
      new_graphs = Pretty.time_rounder("minute", graphs)      
    elsif length < 86400
      new_graphs = Pretty.time_rounder("hour", graphs)
    elsif length < 11536000 #31536000
      new_graphs = Pretty.time_rounder("day", graphs)
    else 
      new_graphs = Pretty.time_rounder("month", graphs)
    end
  end
  
  def self.time_rounder(granularity, graphs)
    new_graphs = {}
    case granularity
    when "second"
      return graphs
    when "minute"
      graphs.each do |graph|
        time = Time.parse(graph["label"])
        if new_graphs[time.strftime("%b %d, %Y, %H:%m")].nil?
          new_graphs[time.strftime("%b %d, %Y, %H:%m")] = {"label" => time.strftime("%b %d, %Y, %H:%m"), "value" => graph["value"].to_i}
        else
          new_graphs[time.strftime("%b %d, %Y, %H:%m")]["value"] += graph["value"].to_i
        end
      end
      final_graphs = new_graphs.sort{|x,y| Time.parse(x["label"]).to_i<=>Time.parse(y["label"]).to_i}
    when "hour"
      graphs.each do |graph|
        time = Time.parse(graph["label"])
        if new_graphs[time.strftime("%b %d, %Y, %H")].nil?
          new_graphs[time.strftime("%b %d, %Y, %H")] = {"label" => time.strftime("%b %d, %Y, %H"), "value" => graph["value"].to_i}
        else
          new_graphs[time.strftime("%b %d, %Y, %H")]["value"] += graph["value"].to_i
        end
      end
      final_graphs = new_graphs.sort{|x,y| Time.parse(x["label"]).to_i<=>Time.parse(y["label"]).to_i}
    when "day"
      graphs.each do |graph|
        time = Time.parse(graph["label"])
        if new_graphs[time.strftime("%b %d, %Y")].nil?
          new_graphs[time.strftime("%b %d, %Y")] = {"label" => time.strftime("%b %d, %Y"), "value" => graph["value"].to_i}
        else
          new_graphs[time.strftime("%b %d, %Y")]["value"] += graph["value"].to_i
        end
      end
      final_graphs = new_graphs.sort{|x,y| Time.parse(x["label"]).to_i<=>Time.parse(y["label"]).to_i}
    when "month"
      graphs.each do |graph|
        time = Time.parse(graph["label"])
        if new_graphs[time.strftime("%b %Y")].nil?
          new_graphs[time.strftime("%b %Y")] = {"label" => time.strftime("%b %Y"), "value" => graph["value"].to_i}
        else
          new_graphs[time.strftime("%b %Y")]["value"] += graph["value"].to_i
        end
      end
    end
    final_graphs = []
    new_graphs.keys.sort.each do |graph_key|
      final_graphs << new_graphs[graph_key]
    end
    final_graphs = final_graphs.sort{|x,y| Time.parse(x["label"]).to_i<=>Time.parse(y["label"]).to_i}
    return final_graphs
  end
end

