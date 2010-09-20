def sanitize_tags(tags)
  phrases = tags.scan(/(\".*?\")/).flatten
  singles = tags.gsub(Regexp.new(phrases.join("|")), "").gsub(/ +/, " ").split(" ")
  return (singles+phrases).join(",")
end
require 'faster_csv'
gg = FasterCSV::open("../data/tags/combined.csv", "r").collect{|row| row}
headers = gg[0]
data_file = []
gg[1..gg.length-1].each do |row|
data_file << Photo.new({"tag_category_id" => TagCategory.find_by_name(row[3]).nil? ? (TagCategory.new(:name => row[3]).save;TagCategory.find_by_name(row[3])).id : TagCategory.find_by_name(row[3]).id, 
"flickr_id" => row[7], 
"photopage_url" => row[10], 
"owner" => row[9], 
"owner_realname" => row[6], 
"taken_at" => Time.parse(row[1]),
"updated_at" => Time.parse(row[2]),
"lat" => row[8], 
"lon" => row[0],
"views" => row[5], 
"tags" => sanitize_tags(row[4]).split(",").collect{|t| Tag.find_by_slug(t.downcase.gsub(" ","_")).nil? ? (Tag.new(:slug => t.downcase.gsub(" ", "_"), :term => t).save;Tag.find_by_slug(t.downcase.gsub(" ","_"))) : Tag.find_by_slug(t.downcase.gsub(" ","_"))}      }).save
end