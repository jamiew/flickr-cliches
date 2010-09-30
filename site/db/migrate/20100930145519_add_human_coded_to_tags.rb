class AddHumanCodedToTags < ActiveRecord::Migration
  def self.up
    add_column :tags, :human_coded, :boolean
  end

  def self.down
    remove_column :tags, :human_coded
  end
end
