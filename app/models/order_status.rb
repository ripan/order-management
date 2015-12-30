class OrderStatus < ActiveRecord::Base
  belongs_to :order
  validates :name, presence: true, uniqueness: true
end
