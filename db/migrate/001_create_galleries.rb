class CreateGalleries < ActiveRecord::Migration
  def self.up
    create_table :galleries do |t|
      t.string :name, :limit => Gallery::NAME_LENGTH_RANGE.last, :null => false
      t.string :permalink, :thumbnail, :website, :null => false
      t.text :description
      t.integer :views, :rand_id, :initial_votes, :milks, :reports, :default => 0
      t.boolean :enabled, :default => true
      t.references :tag, :null => false

      t.timestamps
    end
    add_index :galleries, :enabled
    add_index :galleries, :tag_id
  end

  def self.down
    drop_table :galleries
  end
end