require "rails_helper"

'''
post /api/users/:user_id/accounts/:account_id/consumers
patch /api/users/:user_id/accounts/:account_id/consumers/:id
put /api/users/:user_id/accounts/:account_id/consumers/:id
delete /api/users/:user_id/accounts/:account_id/consumers/:id
'''

RSpec.describe "Api::V1::Consumers", type: :request do 

  subject(:auth_user) do
    post "/api/authentication", params: {user: {email: user.email, password: user.password}}
    token = response.body
    JSON.parse(token)["token"]
  end
  let(:user) { create(:user) }
  let(:account) {create(:account,user: user)}
  

  describe 'create' do    
    context 'valid params' do 
      it 'return created' do 
        token = auth_user 
        params = {
          name: 'Natan',
          account_id: account.id
        }

        post "/api/users/#{user.id}/accounts/#{account.id}/consumers",
        headers: {"Authorization": "Bearer #{token}"},
        params: {consumer: params }

        expect(response).to have_http_status(:created)
        expect(response.body).to include_json({
          id: 1,
          name: "Natan",
          total_consumed: "0.0",
          account_id: 1
        })  
      end
    end

    context 'invalid params' do 
      it 'without account' do 
        token = auth_user 
        params = {
          name: 'Natan'
        }
  
        post "/api/users/#{user.id}/accounts/#{account.id}/consumers",
        headers: {"Authorization": "Bearer #{token}"},
        params: {consumer: params }
        
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include_json({
          "error" => "Validation failed: Account must exist"
        })
      end

      it 'without params' do 
        token = auth_user 

        post "/api/users/#{user.id}/accounts/#{account.id}/consumers",
        headers: {"Authorization": "Bearer #{token}"},
        params: {consumer: {} }

 
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include_json({
          "error" => "param is missing or the value is empty: consumer"
        })
      end
    end 
  end

  describe 'update' do 
    let(:create_consumer) {create(:consumer,account: account)}

    it 'name' do 
      consumer = create_consumer
      params = {
        name: "CIBORGUE"
      }

      patch "/api/users/#{user.id}/accounts/#{account.id}/consumers/#{consumer.id}"
      

    end
  end

end