require "rails_helper"

RSpec.describe "Api::V1::Accounts", type: :request do
  subject(:auth_user) do
    post "/api/authentication", params: {user: {email: user.email, password: user.password}}
    token = response.body
    JSON.parse(token)
  end
  let(:user) { create(:user) }

  describe "GET /index" do
    let(:accounts) do
      create(:account, user: user)
      create(:account, user: user)
      create(:account, user: user)
    end

    context "valid User" do
      it "list accounts current_user" do
        token = auth_user["token"]
        accounts
        get "/api/users/#{user.id}/accounts", headers: {"Authorization": "Bearer #{token}"}

        expect(response).to have_http_status(200)
      end
    end

    context "invalid User" do
      it "unauthorized" do
        post "/api/authentication", params: {user: {email: user.email, password: "123498"}}
        expect(response).to have_http_status(401)
      end
    end
  end

  describe "POST /create" do
    context "valid params" do
      it "return created" do
        token = auth_user["token"]
        account = {
          description: "Testando 1",
          user_id: user.id
        }

        post "/api/users/#{user.id}/accounts",
          headers: {"Authorization": "Bearer #{token}"},
          params: {account: account}

        expect(response).to have_http_status(201)
        expect(response.body).to include_json({
          id: 1,
          total_account: "0.0",
          status: "open",
          description: "Testando 1",
          user_id: 1
        })
      end
    end

    context "invalid params" do
      it "empty params" do
        token = auth_user["token"]
        account = {}

        post "/api/users/#{user.id}/accounts",
          headers: {"Authorization": "Bearer #{token}"},
          params: {account: account}

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).to eq({
          "error" => "param is missing or the value is empty: account"
        })
      end

      it "empty user" do
        token = auth_user["token"]
        account = {
          description: "Testando 1",
          status: "closed"
        }

        post "/api/users/#{user.id}/accounts",
          headers: {"Authorization": "Bearer #{token}"},
          params: {account: account}

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).to eq({
          "error" => "Validation failed: User must exist"
        })
      end
    end
  end

  describe "DELETE /destroy" do
    let(:account) { create(:account, user: user, status: "open") }

    it "return ok" do
      token = auth_user["token"]
      delete "/api/users/#{user.id}/accounts/#{account.id}", headers: {"Authorization": "Bearer #{token}"}

      expect(response).to have_http_status(:ok)
    end
  end
end
