class Base < Grape::API
  include Defaults
  mount V1::Clients
  mount V1::Products
  mount V1::Orders
  mount V1::LineItems
  # mount API::V1::AnotherResource
end
