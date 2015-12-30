module V1
  class Clients < Grape::API
    include Defaults
    resource :clients do

      # curl http://order-management.dev/api/v1/clients.json
      desc "Return all clients"
      get do
        Client.all
      end

      # curl http://order-management.dev/api/v1/clients/1.json
      desc "Return a client"
      params do
        requires :id, type: String, desc: "ID of the client"
      end
      get ":id", root: "client" do
        Client.where(id: params[:id]).first!
      end

      # curl http://order-management.dev/api/v1/clients.json -d "name=jay&email=jay@gmail.com" -v
      desc "Create a client"
      params do
        requires :name, type: String
        requires :email, type:String
      end
      post do
        Client.create!(
          {
            name:params[:name],
            email:params[:email]
          }
        )
      end

      # curl -X DELETE http://order-management.dev/api/v1/clients/2.json
      desc "delete client"
      params do
        requires :id, type: String
      end
      delete ':id' do
        Client.find(params[:id]).destroy!
      end

      # curl -X PUT http://order-management.dev/api/v1/clients/60.json -d "name=ripan&email=jay@gmail.com"
      desc "update an client data"
      params do
        requires :id, type: String
        requires :name, type: String
        requires :email, type:String
      end
      put ':id' do
        Client.find(params[:id]).update(
          {
            name:params[:name],
            email:params[:email]
          }
        )
      end

    end
  end
end
