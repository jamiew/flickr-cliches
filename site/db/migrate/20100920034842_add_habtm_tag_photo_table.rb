class AddHabtmTagPhotoTable < ActiveRecord::Migration
  def self.up
    create_table :photos_tags do |t|
      t.column :photo_id, :integer
      t.column :tag_id, :integer
    end
  end

  def self.down
    drop_table :photos_tags
  end
end
