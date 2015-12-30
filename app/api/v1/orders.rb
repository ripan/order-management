module V1
  class Orders < Grape::API
    include Defaults
    resource :orders do

      # curl http://order-management.dev/api/v1/orders
      desc "Return all orders"
      get do
        Order.all
      end

      # curl http://order-management.dev/api/v1/orders/1
      desc "Return a order"
      params do
        requires :id, type: String, desc: "ID of the order"
      end
      get ":id", root: "order" do
        Order.where(id: params[:id]).first!
      end

      # curl http://order-management.dev/api/v1/orders/1/line_items
      desc "Return a order items"
      params do
        requires :id, type: String, desc: "ID of the order"
      end
      get ":id/line_items", root: "order" do
        Order.find(params[:id]).line_items
      end

      # curl http://order-management.dev/api/v1/orders -d '{"client_id":1,"date":"2015-12-13","line_items":[{"product_id":1,"quantity":4}]}' -H Content-Type:application/json -v
      desc "Create a order"
      params do
        requires :date, type:DateTime
        requires :client_id, type:String
        optional :line_items, type:Array
      end
      post do
        order = Order.new(client: Client.find(params[:client_id]),  date: params[:date].to_time)
        order.order_status =  params[:line_items].blank? ? OrderStatus.find_by_name("DRAFT") : OrderStatus.find_by_name("PLACED")

        if order.has_past_date?
          error!({ error: 'unexpected error', message: 'Date must not be in the past' }, 500)
        end

        unless params[:line_items].blank?
          params[:line_items].each do |line_item|
            order.line_items.build(product: Product.find(line_item.product_id), quantity: line_item.quantity)
          end
        end

        order.save!
      end

      # curl -X DELETE http://order-management.dev/api/v1/orders/2
      desc "delete order"
      params do
        requires :id, type: String
      end
      delete ':id' do
        error!({ error: 'Method Not Allowed', detail: 'Order cannot be deleted' }, 405)
      end

      # curl -X PUT http://order-management.dev/api/v1/orders/9 -d '{"client_id":1,"date":"2015-12-13","order_status":"PLACED", "line_items":[{"product_id":1,"quantity":5}]}' -H Content-Type:application/json -v
      desc "update an order data"
      params do
        requires :date, type:DateTime
        requires :order_status, type:String, values:OrderStatus.pluck('name')
      end
      put ':id' do

        order = Order.find(params[:id])
        if order.status != "DRAFT"
          error!({ error: 'unexpected error', message: 'changes can be made only to orders in DRAFT state' }, 500)
        end

        order.update(
          {
            date:params[:date],
            order_status: OrderStatus.find_by_name(params[:order_status]) 
          }
        )
      end

      # curl -X PUT http://order-management.dev/api/v1/orders/9/update_status -d '{"order_status":"CANCELLED"}' -H Content-Type:application/json -v
      desc "update an order status"
      params do
        requires :order_status, type:String, values:OrderStatus.pluck('name')
      end
      put ':id/update_status' do

        order = Order.find(params[:id])
        if order.status == "PLACED" && params[:order_status] == "DRAFT"
          error!({ error: 'unexpected error', message: 'Order status cannot be changed from PLACED To DEFAULT' }, 500)
        end

        if order.status == "CANCELLED" && params[:order_status] == "DRAFT"
          error!({ error: 'unexpected error', message: 'Order status cannot be changed from CANCELLED To DEFAULT' }, 500)
        end

        order.update(
          {
            order_status: OrderStatus.find_by_name(params[:order_status]) 
          }
        )
      end

      # curl http://order-management.dev/api/v1/orders/9/add_item -d '{line_items":[{"product_id":1,"quantity":5}]}' -H Content-Type:application/json -v
      desc "Add item to an order"
      params do
        requires :id, type: String, desc: "ID of the order"
        at_least_one_of :line_items, type:Array
      end

      post ':id/add_item' do

        order = Order.find(params[:id])
        if order.status != "DRAFT"
          error!({ error: 'unexpected error', message: 'changes can be made only to orders in DRAFT state' }, 500)
        end

        params[:line_items].each do |line_item|
          order.line_items.build(product: Product.find(line_item.product_id), quantity: line_item.quantity)
        end
        order.save!
      end

      # curl -X DELETE http://order-management.dev/api/v1/orders/2/delete_item/11
      desc "Delete item from an order"
      params do
        requires :id, type: String, desc: "ID of the order"
        requires :line_item_id, type: String, desc: "ID of the order item"
      end

      delete ':id/delete_item/:line_item_id' do
        order = Order.find(params[:id])
        if order.status != "DRAFT"
          error!({ error: 'unexpected error', message: 'changes can be made only to orders in DRAFT state' }, 500)
        end
        order.line_items.destroy(params[:line_item_id])
      end

      # curl -X PUT http://order-management.dev/api/v1/orders/9/update_item/10 -d '{"quantity":10}' -H Content-Type:application/json -v
      desc "Update item quantity of order"
      params do
        requires :id, type: String, desc: "ID of the order"
        requires :line_item_id, type: String, desc: "ID of the order item"
        requires :quantity, type: String, desc: "Quantity of the order item"
      end

      put ':id/update_item/:line_item_id' do
        order = Order.find(params[:id])
        if order.status != "DRAFT"
          error!({ error: 'unexpected error', message: 'changes can be made only to orders in DRAFT state' }, 500)
        end

        line_item = order.line_items.find(params[:line_item_id])
        line_item.update(
          {
            quantity:params[:quantity]
          }
        )
      end

    end
  end
end
