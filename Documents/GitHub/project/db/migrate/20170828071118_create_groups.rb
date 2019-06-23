class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.string :name
      t.string :created_by
      t.string :desc
      t.timestamps null: false
    end
  end
end
