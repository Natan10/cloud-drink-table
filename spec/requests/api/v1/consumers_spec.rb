require "rails_helper"

RSpec.describe "Api::V1::Consumers", type: :request do
  subject(:auth_user) do
    post "/api/authentication", params: {user: {email: user.email, password: user.password}}
    token = response.body
    JSON.parse(token)["token"]
  end
  let(:user) { create(:user) }
  let(:account) { create(:account, user: user) }

  describe "create" do
    context "valid params" do
      it "return created" do
        token = auth_user
        params = {
          name: "Natan",
          account_id: account.id
        }

        post "/api/users/#{user.id}/accounts/#{account.id}/consumers",
          headers: {"Authorization": "Bearer #{token}"},
          params: {consumer: params}

        expect(response).to have_http_status(:created)
        expect(response.body).to include_json({
          id: 1,
          name: "Natan",
          total_consumed_cents: "0.0",
          account_id: 1
        })
      end
    end

    context "invalid params" do
      it "without account" do
        token = auth_user
        params = {
          name: "Natan"
        }

        post "/api/users/#{user.id}/accounts/#{account.id}/consumers",
          headers: {"Authorization": "Bearer #{token}"},
          params: {consumer: params}

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include_json({
          "error" => "Validation failed: Account must exist"
        })
      end

      it "without params" do
        token = auth_user

        post "/api/users/#{user.id}/accounts/#{account.id}/consumers",
          headers: {"Authorization": "Bearer #{token}"},
          params: {consumer: {}}

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include_json({
          "error" => "param is missing or the value is empty: consumer"
        })
      end
    end
  end

  describe "update" do
    let(:create_consumer) { create(:consumer, account: account) }

    context "valid params" do
      it "name" do
        token = auth_user
        consumer = create_consumer
        params = {
          name: "CIBORGUE"
        }

        patch "/api/users/#{user.id}/accounts/#{account.id}/consumers/#{consumer.id}",
          headers: {"Authorization": "Bearer #{token}"},
          params: {consumer: params}

        expect(response).to have_http_status(:ok)
      end
    end

    context "invalid params" do
      it "whitout params" do
        token = auth_user
        consumer = create_consumer

        patch "/api/users/#{user.id}/accounts/#{account.id}/consumers/#{consumer.id}",
          headers: {"Authorization": "Bearer #{token}"},
          params: {consumer: {}}

        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "wrong id" do
        token = auth_user

        patch "/api/users/#{user.id}/accounts/#{account.id}/consumers/999",
          headers: {"Authorization": "Bearer #{token}"},
          params: {consumer: {}}

        expect(response).to have_http_status(:not_found)
        expect(response.body).to include_json({
          "error" => "Couldn't find Consumer with 'id'=999"
        })
      end
    end
  end

  describe "show" do
    let(:consumer) { create(:consumer, account: account) }

    it 'valid id' do 
      token = auth_user
      create_list(:item,3,consumer: consumer)

      get "/api/users/#{user.id}/accounts/#{account.id}/consumers/#{consumer.id}",
      headers: {"Authorization": "Bearer #{token}"}
      expect(response).to have_http_status(200)  
    end
    
    it 'invalid id' do 
      token = auth_user
      create_list(:item,3,consumer: consumer)

      get "/api/users/#{user.id}/accounts/#{account.id}/consumers/5",
      headers: {"Authorization": "Bearer #{token}"}

      expect(response).to have_http_status(404) 
      expect(response.body).to include_json({
        "error" => "Couldn't find Consumer with 'id'=5"
      })
    end
  end
  

  describe "delete" do
    it "return 200" do
      token = auth_user
      consumer = create(:consumer, account: account)

      delete "/api/users/#{user.id}/accounts/#{account.id}/consumers/#{consumer.id}",
        headers: {"Authorization": "Bearer #{token}"}

      expect(response).to have_http_status(:ok)
    end

    it "return 404" do
      token = auth_user

      delete "/api/users/#{user.id}/accounts/#{account.id}/consumers/500",
        headers: {"Authorization": "Bearer #{token}"}

      expect(response).to have_http_status(:not_found)
    end
  end
end
