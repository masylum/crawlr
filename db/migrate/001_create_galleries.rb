class CreateGalleries < ActiveRecord::Migration
  def self.up
    create_table :galleries do |t|
      t.string :name, :limit => Gallery::NAME_LENGTH_RANGE.last, :null => false
      t.string :permalink, :thumbnail, :website, :null => false
      t.text :description
      t.integer :views, :rand_id, :initial_votes, :total_votes, :default => 0
      t.boolean :enabled, :default => true
      t.references :tag, :null => false

      t.timestamps
    end
    add_index :galleries, [:enabled, :tag_id, :total_votes, :views, :rand_id], :name => 'galleries_index'
  end

  def self.down
    drop_table :galleries
  end
end