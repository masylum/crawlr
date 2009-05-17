class CreateVotes < ActiveRecord::Migration
  def self.up
    create_table :votes do |t|
      t.string :remote_ip, :type, :null => false
      t.references :gallery, :null => false

      t.timestamps
    end
    add_index :votes, [:gallery_id, :type], :name => 'galleries_index'
  end

  def self.down
    drop_table :votes
  end
end