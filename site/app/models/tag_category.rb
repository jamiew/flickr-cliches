class TagCategory < ActiveRecord::Base
  has_many :tags
  has_many :photos
end
