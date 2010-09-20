class Tag < ActiveRecord::Base
  belongs_to :tag_categories
  has_and_belongs_to_many :photos
end
