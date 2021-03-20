class AuthenticationTokenService
  TOKEN_SECRET = 'my$ecretK3y'
  TOKEN_TYPE = 'HS256'

  def self.encode(user_id)
    payload = {user_id: user_id}
    token = JWT.encode payload,TOKEN_SECRET,TOKEN_TYPE
    token
  end

  def self.decode(token)
    decoded_token = JWT.decode token, TOKEN_SECRET, true, { algorithm: TOKEN_TYPE }
    decoded_token
  end

end