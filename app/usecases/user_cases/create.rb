module UserCases
  class Create < Micro::Case
    attribute :username, default: -> (value) { value.to_s.strip}
    attribute :email, default: -> (value) { value.to_s.strip}
    attribute :password, default: -> (value) { value.to_s.strip}
    attribute :password_confirmation, default: -> (value) { value.to_s.strip}
    attribute :photo

    def call!  
      return Failure :username_empty if username.nil? || username.empty?
      return Failure :email_empty if email.nil? || email.empty?
      return Failure :password_empty if password.nil? || password.empty?
      return Failure :password_confirmation_empty if password_confirmation.nil? || password_confirmation.empty?
      return Failure :password_error if password != password_confirmation   
      
      user = User.new(
        username: username,
        email: email, 
        password: password,
        password_confirmation: password_confirmation
      )

      if user.save
        # Enviar email de boas vindas e informaçoes da conta
        return Success result: {user: user}
      end

      Failure :user_create_error, result: {errors: user.erros}


    rescue ActionController::ParameterMissing => ex
      Failure(:parameter_missing, result: {msg: ex.message})
    end
  end
end