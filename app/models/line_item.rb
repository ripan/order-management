class LineItem < ActiveRecord::Base
  belongs_to :order
  belongs_to :product
  validates :quantity, length: { minimum: 1 }
end
