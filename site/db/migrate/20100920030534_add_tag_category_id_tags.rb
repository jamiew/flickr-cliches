class AddTagCategoryIdTags < ActiveRecord::Migration
  def self.up
    add_column :tags, :tag_category_id, :integer
  end

  def self.down
    remove_column :tags, :tag_category_id
  end
end
