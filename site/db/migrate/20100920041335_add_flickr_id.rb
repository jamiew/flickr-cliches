class AddFlickrId < ActiveRecord::Migration
  def self.up
    add_column :photos, :flickr_id, :string
  end

  def self.down
    remove_column :photos, :flickr_id
  end
end
