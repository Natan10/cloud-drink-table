require "rails_helper"

RSpec.describe "Api::V1::Accounts", type: :request do
  subject(:auth_user) do
    post "/api/authentication", params: {user: {email: user.email, password: user.password}}
    token = response.body
    JSON.parse(token)
  end
  let(:user) { create(:user) }

  describe "GET /index" do
    let(:create_accounts) do
      create(:account, user: user)
      create(:account, user: user)
      create(:account, user: user)
    end

    context "valid User" do
      it "list accounts current_user" do
        token = auth_user["token"]
        create_accounts
        
        get "/api/accounts", headers: {"Authorization": "Bearer #{token}"}
        
        accounts = JSON.parse(response.body)
        expect(response).to have_http_status(200)
        expect(accounts["user"]["accounts"].count).to eq(3)
      end
    end

    context "invalid User" do
      it "unauthorized" do
        post "/api/authentication", params: {user: {email: user.email, password: "123498"}}
        expect(response).to have_http_status(401)
      end
    end
  end
  
  # describe "POST /create" do
  #   context "valid params" do
  #     it "return created" do
  #       token = auth_user["token"]
  #       account = {
  #         description: "Testando 1",
  #         user_id: user.id,
  #       }

  #       post "/api/accounts",
  #         headers: {"Authorization": "Bearer #{token}"},
  #         params: {account: account}

  #       expect(response).to have_http_status(201)
  #       expect(response.body).to include_json({
  #         "account": {
  #           id: 1,
  #           user: 1,
  #           description: "Testando 1",
  #           status: "open",
  #           total_account: "0.0"
  #         }
  #       })
  #     end
  #   end

  #   context "invalid params" do
  #     it "empty params" do
  #       token = auth_user["token"]
  #       account = {}

  #       post "/api/accounts",
  #         headers: {"Authorization": "Bearer #{token}"},
  #         params: {account: account}

  #       expect(response).to have_http_status(:unprocessable_entity)
  #       expect(JSON.parse(response.body)).to eq({
  #         "error" => "param is missing or the value is empty: account"
  #       })
  #     end
    

  #     it "invalid user" do
  #       token = auth_user["token"]
  #       account = {
  #         description: "Testando 1",
  #         status: "closed",
  #         user_id: "5"
  #       }

  #       post "/api/accounts",
  #         headers: {"Authorization": "Bearer #{token}"},
  #         params: {account: account}

  #       expect(response).to have_http_status(:unprocessable_entity)
  #       expect(JSON.parse(response.body)).to eq({
  #         "error" => "Validation failed: User must exist"
  #       })
  #     end
  #   end
  # end

  # describe "DELETE /destroy" do
  #   let(:account) { create(:account, user: user, status: "open") }

  #   it "return ok" do
  #     token = auth_user["token"]
  #     delete "/api/accounts/#{account.id}", headers: {"Authorization": "Bearer #{token}"}

  #     expect(response).to have_http_status(:ok)
  #   end
  # end

  # describe "Total Account" do
  #   let(:account) { create(:account, status: "open") }
  #   let(:consumer) { create(:consumer, account: account) }
  #   let(:items) { create_list(:item, 3, price_cents: 50.0, quantity: 1, consumer: consumer) }

  #   context "valid account" do
  #     it "total account" do
  #       token = auth_user["token"]
  #       items
  #       get "/api/accounts/#{account.id}/account_total",
  #         headers: {"Authorization": "Bearer #{token}"}

  #       expect(response.body).to include_json({
  #         account_id: 1,
  #         account_total: "150.0"
  #       })
  #     end
  #   end

  #   context "invalid account" do
  #     it "return not found" do
  #       token = auth_user["token"]
  #       items
  #       get "/api/accounts/50/account_total",
  #         headers: {"Authorization": "Bearer #{token}"}

  #       expect(response.body).to include_json({
  #         "error" => "Couldn't find Account with 'id'=50"
  #       })
  #     end
  #   end
  # end
end
