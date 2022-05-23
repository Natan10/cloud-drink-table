# frozen_string_literal: true

module UserCases
  class Create < Micro::Case
    attribute :username, default: -> (value) { value.to_s.strip}
    attribute :email, default: -> (value) { value.to_s.strip}
    attribute :password
    attribute :password_confirmation
    attribute :photo

    def call!  
      validate_params.then(:create_user)     
    end

    private

    def validate_params 
      return Failure :username_empty if username.nil? || username.empty?
      return Failure :email_empty if email.nil? || email.empty?
      return Failure :password_empty if password.nil? || password.empty?
      return Failure :password_confirmation_empty if password_confirmation.nil? || password_confirmation.empty?
      return Failure :password_error if password != password_confirmation  

      Success(:valid_params)
    end

    def create_user
      user = User.new(
        username: username,
        email: email, 
        password: password,
        password_confirmation: password_confirmation
      )

      if user.save
        return Success result: {user: user}
      end

      Failure :user_create_error, result: {errors: user.erros} 
    end
  end
end