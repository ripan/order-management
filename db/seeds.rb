# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


LineItem.destroy_all
Order.destroy_all
Product.destroy_all
OrderStatus.destroy_all
Client.destroy_all


client = Client.create(name: 'ripan',email: 'ripan@gmail.com')

%w(DRAFT PLACED CANCELLED).each do |status|
  OrderStatus.create(name: status)
end

for i in 1..5
  Product.create(name: "Product #{i}",price: 100 * i)
end

order = Order.new(order_status: OrderStatus.first, client: client,  date: DateTime.now)

order.line_items.build(product: Product.first, quantity: 2)
order.line_items.build(product: Product.last, quantity: 4)

order.save!