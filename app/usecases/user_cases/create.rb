# frozen_string_literal: true

module UserCases
  class Create < ::Micro::Case
    attribute :username, default: -> (value) { value.to_s.strip}
    attribute :email, default: -> (value) { value.to_s.strip}
    attribute :password
    attribute :password_confirmation
    attribute :photo

    def call!  
      create_user
    end

    private

    def create_user
      user = User.new(
        username: username,
        email: email, 
        password: password,
        password_confirmation: password_confirmation
      )

      if user.save
        send_email
        return Success result: {user: user}
      end

      Failure :user_create_error, result: {errors: user.errors} 
    end

    def send_email
      UserMailer.with(name: username, email: email).user_created_email.deliver_later
    end
  end
end