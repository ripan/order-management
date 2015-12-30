module V1
  class LineItems < Grape::API
    include Defaults
    resource :line_items do

      # curl http://order-management.dev/api/v1/line_items.json
      desc "Return all line_items"
      get do
        LineItem.all
      end

      # curl http://order-management.dev/api/v1/line_items/1.json
      desc "Return a line_item"
      params do
        requires :id, type: String, desc: "ID of the line_item"
      end
      get ":id", root: "line_item" do
        LineItem.where(id: params[:id]).first!
      end

      # curl http://order-management.dev/api/v1/line_items.json -d '{"product_id":1,"quantity":5}' -H Content-Type:application/json -v
      desc "Create a line_item"
      params do
        requires :product_id, type: String
        requires :quantity, type:String
      end
      post do
        LineItem.create!(
          {
            product:Product.find(params[:product_id]),
            quantity:params[:quantity],
          }
        )
      end

      # curl -X DELETE http://order-management.dev/api/v1/line_items/2.json
      desc "delete line_item"
      params do
        requires :id, type: String
      end
      delete ':id' do
        LineItem.find(params[:id]).destroy!
      end

      # curl -X PUT http://order-management.dev/api/v1/line_items/60.json -d '{"quantity":4}' -H Content-Type:application/json -v
      desc "update an line_item data"
      params do
        requires :id, type: String
        requires :quantity, type:String
      end
      put ':id' do
        LineItem.find(params[:id]).update(
          {
            quantity:params[:quantity]
          }
        )
      end

    end
  end
end
