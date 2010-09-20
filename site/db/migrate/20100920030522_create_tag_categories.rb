class CreateTagCategories < ActiveRecord::Migration
  def self.up
    create_table :tag_categories do |t|
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :tag_categories
  end
end
