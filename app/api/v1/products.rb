module V1
  class Products < Grape::API
    include Defaults
    resource :products do

      # curl http://order-management.dev/api/v1/products
      desc "Return all products"
      get do
        Product.all
      end

      # curl http://order-management.dev/api/v1/products/1
      desc "Return a product"
      params do
        requires :id, type: String, desc: "ID of the product"
      end
      get ":id", root: "product" do
        Product.where(id: params[:id]).first!
      end

      # curl http://order-management.dev/api/v1/products -d "name=productname&price=30" -v
      desc "Create a product"
      params do
        requires :name, type: String
        requires :price, type:Float
        #requires :vat, type:Float
      end
      post do
        Product.create!(
          {
            name:params[:name],
            price:params[:price],
            #vat:params[:vat]
          }
        )
      end

      # curl -X DELETE http://order-management.dev/api/v1/products/2
      desc "delete product"
      params do
        requires :id, type: String
      end
      delete ':id' do
        Product.find(params[:id]).destroy!
      end

      # curl -X PUT http://order-management.dev/api/v1/products/60 -d "name=productname1&price=30"
      desc "update an product data"
      params do
        requires :id, type: String
        requires :name, type: String
        requires :price, type:Float
        #requires :vat, type:Float
      end
      put ':id' do
        Product.find(params[:id]).update(
          {
            name:params[:name],
            price:params[:price],
            #vat:params[:vat]
          }
        )
      end

    end
  end
end
