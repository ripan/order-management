class Order < ActiveRecord::Base
  belongs_to :order_status
  belongs_to :client
  has_many :line_items, dependent: :destroy

  def status
  	self.order_status.name
  end

  def has_past_date?
  	self.date.to_date < Date.today
  end
end
