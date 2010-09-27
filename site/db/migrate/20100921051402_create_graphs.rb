class CreateGraphs < ActiveRecord::Migration
  def self.up
    create_table :graphs do |t|
      t.string :graph_title

      t.timestamps
    end
  end

  def self.down
    drop_table :graphs
  end
end
