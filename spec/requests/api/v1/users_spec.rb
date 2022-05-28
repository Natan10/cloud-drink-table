require "rails_helper"

RSpec.describe "Api::V1::Users", type: :request do
  describe "POST" do
    subject(:create_user) {
      post "/api/users",
        params: {user: user_params},
        headers: {"ACCEPT" => "application/json"}
    }

    let(:photo) { fixture_file_upload("beagle.jpg") }
    let(:user_params) { attributes_for(:user, photo: photo) }

    context "valid user" do
      it "valid params" do
        
        expect {
          create_user
        }.to have_enqueued_job(ActionMailer::MailDeliveryJob)
        
        expect(response).to have_http_status(:created)
      end
    end

    context "invalid user" do
      let(:user_params) { nil }

      it "without params" do
        create_user  
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).to eq({
          "error" => "param is missing or the value is empty: user"
        })
      end

      it "invalid params" do
        user = {username: "Teste1", email: "test1@com"}
        post "/api/users", params: {user: user},
                           headers: {"ACCEPT" => "application/json"}

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "PUT" do 
    subject(:auth_user) do
      post "/api/authentication", params: {user: {email: user.email, password: user.password}}
      token = response.body
      JSON.parse(token)
    end
    let(:photo) { fixture_file_upload("beagle.jpg") }
    let(:updated_photo) { fixture_file_upload("bulldog.jpg") }
    let(:user) { create(:user, photo: photo) }
    
    
    it "valid params" do
      
      token = auth_user["token"]
      params = {
        username: "teste1",
        photo: updated_photo
      }
  
      put "/api/users/#{user.id}",
      params: {user: params}, 
      headers: {"Authorization": "Bearer #{token}"}

      expect(response).to have_http_status(:ok)  
    end

    it "invalid user" do 
      token = auth_user["token"]
      params = {
        username: "teste1",
        photo: updated_photo
      }

      put "/api/users/100",
      params: {user: params}, 
      headers: {"Authorization": "Bearer #{token}"}

      expect(response).to have_http_status(:not_found)  
    end

    it "whitout params" do 
      token = auth_user["token"]
      put "/api/users/#{user.id}",
      params: {user: {}}, 
      headers: {"Authorization": "Bearer #{token}"}
      
      expect(response).to have_http_status(:unprocessable_entity) 
    end

  end
end
