class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :name
      t.decimal :price
      t.decimal :vat, :default => 20

      t.timestamps null: false
    end
  end
end
