class AddLegacyIdToProperties < ActiveRecord::Migration
  def self.up
    add_column :properties, :legacy_id, :integer
  end

  def self.down
    remove_column :properties, :legacy_id
  end
end
