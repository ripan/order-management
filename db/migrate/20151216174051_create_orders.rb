class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.references :order_status, index: true, foreign_key: true
      t.datetime :date
      t.references :client, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
