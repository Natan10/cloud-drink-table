require "rails_helper"

RSpec.describe "Api::V1::Consumers", type: :request do
  subject(:auth_user) do
    post "/api/authentication", params: {user: {email: user.email, password: user.password}}
    token = response.body
    JSON.parse(token)["token"]
  end
  let(:user) { create(:user) }
  let(:account) { create(:account, user: user) }

  describe "POST /create" do
    context "valid params" do
      it "return created" do
        token = auth_user
        params = {
          name: "Natan",
          account_id: account.id,
        }

        post "/api/consumers",
          headers: {"Authorization": "Bearer #{token}"},
          params: {consumer: params}

        expect(response).to have_http_status(:created)
        expect(response.body).to include_json({
          "consumer": {
            id: 1,
            name: "Natan",
            total_consumed: "0.0",
            account_id: 1
          }
        })
      end
    end

    context "invalid params" do
      it "invalid account" do
        token = auth_user
        params = {
          name: "Natan"
        }

        post "/api/consumers",
          headers: {"Authorization": "Bearer #{token}"},
          params: {consumer: params}

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include_json({
          "error" => "Validation failed: Account must exist"
        })
      end

      it "without params" do
        token = auth_user

        post "/api/consumers",
          headers: {"Authorization": "Bearer #{token}"},
          params: {consumer: {}}

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include_json({
          "error" => "param is missing or the value is empty: consumer"
        })
      end
    end
  end

  describe "PUT /update" do
    let(:create_consumer) { create(:consumer, account: account) }

    context "valid params" do
      it "name" do
        token = auth_user
        consumer = create_consumer
        params = {
          name: "CIBORGUE"
        }

        patch "/api/consumers/#{consumer.id}",
          headers: {"Authorization": "Bearer #{token}"},
          params: {consumer: params}

        expect(response).to have_http_status(:ok)
      end
    end

    context "invalid params" do
      it "whitout params" do
        token = auth_user
        consumer = create_consumer

        patch "/api/consumers/#{consumer.id}",
          headers: {"Authorization": "Bearer #{token}"},
          params: {consumer: {}}

        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "wrong id" do
        token = auth_user

        patch "/api/consumers/999",
          headers: {"Authorization": "Bearer #{token}"},
          params: {consumer: {}}

        expect(response).to have_http_status(:not_found)
        expect(response.body).to include_json({
          "error" => "Couldn't find Consumer with 'id'=999"
        })
      end
    end
  end

  describe "GET /show" do
    let(:consumer) { create(:consumer, account: account) }

    it "valid id" do
      token = auth_user
      create_list(:item, 3, consumer: consumer)

      get "/api/consumers/#{consumer.id}",
        headers: {"Authorization": "Bearer #{token}"}
      expect(response).to have_http_status(200)
    end

    it "invalid id" do
      token = auth_user
      create_list(:item, 3, consumer: consumer)

      get "/api/consumers/5",
        headers: {"Authorization": "Bearer #{token}"}

      expect(response).to have_http_status(404)
      expect(response.body).to include_json({
        "error" => "Couldn't find Consumer with 'id'=5"
      })
    end
  end

  describe "DELETE /delete" do
    it "return 200" do
      token = auth_user
      consumer = create(:consumer, account: account)

      delete "/api/consumers/#{consumer.id}",
        headers: {"Authorization": "Bearer #{token}"}

      expect(response).to have_http_status(:ok)
    end

    it "return 404" do
      token = auth_user

      delete "/api/consumers/500",
        headers: {"Authorization": "Bearer #{token}"}

      expect(response).to have_http_status(:not_found)
    end
  end

  describe "GET /total_consumed" do 
    let(:account) { create(:account, status: "open") }
    let(:consumer) { create(:consumer, account: account) }
    let(:items) { create_list(:item, 3, price_cents: 50.0, quantity: 1, consumer: consumer) }

    context 'valid consumer' do
      it 'total consumed' do
        token = auth_user
        items
        get "/api/consumers/#{consumer.id}/total_consumer",
          headers: {"Authorization": "Bearer #{token}"}
        
        expect(response.body).to include_json({
          consumer_id:1,
          total_consumer: "150.0"
        })   
      end
    end

    context "invalid consumer" do
      it 'not found' do
        token = auth_user
        items
        get "/api/consumers/100/total_consumer",
          headers: {"Authorization": "Bearer #{token}"}
        
        expect(response.body).to include_json({
          "error" => "Couldn't find Consumer with 'id'=100"
        })   
      end
    end
  end
end
