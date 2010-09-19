class CreatePhotos < ActiveRecord::Migration
  def self.up
    create_table :photos do |t|
      t.float :lon
      t.datetime :taken_at
      t.datetime :updated_at
      t.integer :views
      t.string :owner_realname
      t.float :lat
      t.string :owner
      t.integer :owner_id
      t.string :photopage_url

      t.timestamps
    end
  end

  def self.down
    drop_table :photos
  end
end
