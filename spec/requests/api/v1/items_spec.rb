require "rails_helper"

RSpec.describe "Api::V1::Items", type: :request do
  subject(:auth_user) do
    post "/api/authentication", params: {user: {email: user.email, password: user.password}}
    token = response.body
    JSON.parse(token)["token"]
  end
  let(:user) { create(:user) }
  let(:account) { create(:account, user: user) }
  let(:consumer) { create(:consumer, account: account) }

  describe "POST /create" do
    context "valid params" do
      it "return ok" do
        token = auth_user
        params = {
          name: "Cerveja Preta",
          quantity: 3,
          price: 15
        }
        post "/api/users/#{user.id}/accounts/#{account.id}/consumers/#{consumer.id}/items",
          headers: {"Authorization": "Bearer #{token}"},
          params: {item: params}

        expect(response).to have_http_status(:created)
        expect(response.body).to include_json({
          id: 1,
          name: "Cerveja Preta",
          quantity: 3,
          price_cents: "1500.0",
          consumer_id: 1
        })
      end
    end

    context "invalid params" do
      it "whitout params" do
        token = auth_user
        post "/api/users/#{user.id}/accounts/#{account.id}/consumers/#{consumer.id}/items",
          headers: {"Authorization": "Bearer #{token}"},
          params: {item: {}}

        expect(response).to have_http_status(422)
        expect(response.body).to include_json({
          "error" => "param is missing or the value is empty: item"
        })
      end

      it "invalid consumer_id" do
        token = auth_user
        params = {
          name: "Cerveja Preta",
          quantity: 3,
          price_cents: 18.50
        }
        post "/api/users/#{user.id}/accounts/#{account.id}/consumers/50/items",
          headers: {"Authorization": "Bearer #{token}"},
          params: {item: params}

        expect(response).to have_http_status(422)
        expect(response.body).to include_json({
          "error" => "Validation failed: Consumer must exist"
        })
      end

      it "whitout name" do
        token = auth_user
        params = {
          name: nil,
          quantity: 3,
          price_cents: 18.50,
          consumer_id: consumer.id
        }

        post "/api/users/#{user.id}/accounts/#{account.id}/consumers/#{consumer.id}/items",
          headers: {"Authorization": "Bearer #{token}"},
          params: {item: params}

        expect(response).to have_http_status(422)
        expect(response.body).to include_json({
          "error" => "Validation failed: Name can't be blank"
        })
      end

      it "invalid quantity" do
        token = auth_user
        params = {
          name: "kepoe",
          quantity: -5,
          price_cents: 18.50,
          consumer_id: consumer.id
        }

        post "/api/users/#{user.id}/accounts/#{account.id}/consumers/#{consumer.id}/items",
          headers: {"Authorization": "Bearer #{token}"},
          params: {item: params}

        expect(response).to have_http_status(422)
        expect(response.body).to include_json({
          "error" => "Validation failed: Quantity must be greater than or equal to 0"
        })
      end
    end
  end

  describe "PUT /update" do
    let(:create_item) { create(:item, consumer: consumer) }
    context "valid params" do
      it "return ok" do
        token = auth_user

        params = {
          name: "Batata frita no molho",
          quantity: 2,
          price: 22.85,
          consumer_id: consumer.id
        }

        put "/api/users/#{user.id}/accounts/#{account.id}/consumers/#{consumer.id}/items/#{create_item.id}",
          headers: {"Authorization": "Bearer #{token}"},
          params: {item: params}

        expect(response).to have_http_status(200)
      end
    end

    context "invalid params" do
      it "return 422" do
        token = auth_user

        params = {
          name: "Batata frita no molho",
          quantity: -1,
          price: 22.85,
          consumer_id: consumer.id
        }

        put "/api/users/#{user.id}/accounts/#{account.id}/consumers/#{consumer.id}/items/#{create_item.id}",
          headers: {"Authorization": "Bearer #{token}"},
          params: {item: params}

        expect(response).to have_http_status(422)
      end

      it "not found" do
        token = auth_user

        params = {
          name: "Batata frita no molho",
          quantity: 10,
          price: 22.85,
          consumer_id: consumer.id
        }

        put "/api/users/#{user.id}/accounts/#{account.id}/consumers/#{consumer.id}/items/10",
          headers: {"Authorization": "Bearer #{token}"},
          params: {item: params}

        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe "DELETE /destroy" do
    it "return 200" do
      token = auth_user
      item = create(:item, consumer: consumer)

      delete "/api/users/#{user.id}/accounts/#{account.id}/consumers/#{consumer.id}/items/#{item.id}",
        headers: {"Authorization": "Bearer #{token}"}

      expect(response).to have_http_status(:ok)
    end

    it "return 404" do
      token = auth_user

      delete "/api/users/#{user.id}/accounts/#{account.id}/consumers/#{consumer.id}/items/5",
        headers: {"Authorization": "Bearer #{token}"}

      expect(response).to have_http_status(404)
    end
  end
end
