require 'rails_helper'

describe AuthenticationTokenService, type: :service do
  describe "encode/decode" do
   it 'returns token for user' do
    user = create(:user)

    token = described_class.encode(user.id)
    expect(token).to be_a(String)  
    expect(token).to eq("eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxfQ.DiPWrOKsx3sPeVClrm_j07XNdSYHgBa3Qctosdxax3w")  
   end

   it 'returns decoded token' do
     token = "eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxfQ.DiPWrOKsx3sPeVClrm_j07XNdSYHgBa3Qctosdxax3w"
     decode = described_class.decode(token)

     expect(decode).to eq([{"user_id"=>1},{"alg"=>"HS256"}])  
   end
  
  end
end
