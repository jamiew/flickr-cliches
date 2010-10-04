class Photo < ActiveRecord::Base
  has_and_belongs_to_many :tags
  belongs_to :tag_category
  def url
    return "http://farm4.static.flickr.com/#{self.server}/#{self.flickr_id}"
  end
end
