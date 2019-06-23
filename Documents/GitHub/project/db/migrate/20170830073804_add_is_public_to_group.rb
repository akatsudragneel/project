class AddIsPublicToGroup < ActiveRecord::Migration
  def change
    add_column :groups, :is_public, :boolean
    add_index :groups, :is_public
  end
end
