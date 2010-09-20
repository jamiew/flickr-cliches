class FixHabtmTable < ActiveRecord::Migration
  def self.up
    remove_column :photos_tags, :id
  end

  def self.down
    add_column :photos_tags, :id, :integer
  end
end
