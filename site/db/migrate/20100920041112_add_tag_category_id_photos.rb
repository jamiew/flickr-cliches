class AddTagCategoryIdPhotos < ActiveRecord::Migration
  def self.up
    add_column :photos, :tag_category_id, :integer
  end

  def self.down
    remove_column :photos, :tag_category_id
  end
end
