require 'rails_helper'

RSpec.describe "Api::V1::Authentications", type: :request do
  describe "POST /authenticate" do
    let(:user){ create(:user) }

    context 'valid params' do
      it "authenticate user" do
        post "/api/authentication", params: {user: {email: user.email, password: '123456'} }
        
        expect(response).to have_http_status(:created)  
        expect(JSON.parse(response.body)).to eq({
          "token" => "eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxfQ.DiPWrOKsx3sPeVClrm_j07XNdSYHgBa3Qctosdxax3w"
        })
      end
    end

    context "invalid params" do
      it 'unathorized' do
        post "/api/authentication", params: {user: {email: user.email, password: '12345'} }
        expect(response).to have_http_status(:unauthorized)   
      end  
  
      it 'user not found' do
        post "/api/authentication", params: {user: {email: 'teste@mail.com', password: '12345'} }
        expect(response).to have_http_status(:unprocessable_entity) 
      end
  
      it 'params missing' do
        post "/api/authentication", params: {}

        expect(response).to have_http_status(:unprocessable_entity) 
      end

    end
    
    
    
    
  end
end
