class OrderSerializer < ActiveModel::Serializer
  attributes :id, :date, :created_at, :updated_at, :order_status, :client, :net_total, :gross_total
  has_many :line_items

  def order_status
    object.order_status.name
  end

  def net_total
  	object.line_items.map {|item| item.quantity * item.product.price}.sum
  end
  
  def gross_total
  	object.line_items.map {|item| item.quantity * (item.product.price + (item.product.price * item.product.vat/100))}.sum
  end

end