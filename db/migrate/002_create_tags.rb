class CreateTags < ActiveRecord::Migration
  def self.up
    create_table :tags do |t|
      t.string :name, :null => false
      t.integer :galleries_count, :default => 0
      
      t.timestamps
    end
    add_index :tags, :name
  end
  
  def self.down
    drop_table :tags
  end
end
