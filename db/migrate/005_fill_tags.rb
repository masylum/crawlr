class FillTags < ActiveRecord::Migration
  def self.up
    Tag::TAGS.each do |tag|
      Tag.create(:name => tag)
    end
  end

  def self.down
    Tag.delete_all
  end
end