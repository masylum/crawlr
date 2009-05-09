class CreateFails < ActiveRecord::Migration
  def self.up
    create_table :fails do |t|
      t.string :name, :permalink, :thumbnail, :website, :null => false
      t.text :error
      t.timestamps
    end
  end

  def self.down
    drop_table :fails
  end
end