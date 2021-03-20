require 'rails_helper'

RSpec.describe "Api::V1::Users", type: :request do
  describe "POST" do
    subject(:create_user) { 
      post '/api/users', 
      params: {user: user_params },
      headers: { "ACCEPT" => "application/json" }
    }  

    let(:user_params) { attributes_for(:user) }
  
    context 'valid user' do
      it 'valid params' do
        create_user
        expect(response).to have_http_status(:created)
      end
    end

    context "invalid user" do
      let(:user_params){ nil }

      it 'without params' do
        create_user
        expect(response).to have_http_status(:unprocessable_entity)  
        expect(JSON.parse(response.body)).to eq({
          "error" => "param is missing or the value is empty: user"
        })  
      end

      it 'invalid params' do
        user = { username: 'Teste1', email: 'test1@com'}
        post '/api/users', params: {user: user },
        headers: { "ACCEPT" => "application/json" }

        expect(response).to have_http_status(:unprocessable_entity)  
      end
    end
  end
end
