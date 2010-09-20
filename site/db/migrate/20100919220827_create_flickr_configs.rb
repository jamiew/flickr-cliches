class CreateFlickrConfigs < ActiveRecord::Migration
  def self.up
    create_table :flickr_configs do |t|
      t.string :key
      t.string :secret

      t.timestamps
    end
  end

  def self.down
    drop_table :flickr_configs
  end
end
