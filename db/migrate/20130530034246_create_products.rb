class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :name
      t.text :description
      t.decimal :price
      t.integer :quantity
      t.datetime :available_at
      t.text :tags

      t.timestamps
    end
  end
end
