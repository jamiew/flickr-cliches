class AddPhotoServer < ActiveRecord::Migration
  def self.up
    add_column :photos, :server, :string
  end

  def self.down
    remove_column :photos, :server
  end
end
