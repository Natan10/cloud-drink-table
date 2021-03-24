class AuthenticationTokenService
  @token_conf = Rails.application.credentials.token  
  
  def self.encode(user_id)
    exp = (Time.now + 30.minutes).to_i
    payload = {user_id: user_id, exp: exp}
    JWT.encode payload, @token_conf[:token_secret], @token_conf[:token_type]
  end

  def self.decode(token)
    decoded_token = JWT.decode token, @token_conf[:token_secret], true, {algorithm: @token_conf[:token_type]}
    decoded_token[0] 
  end

end
