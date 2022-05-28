# frozen_string_literal: true

module User
  class Update < ::Micro::Case
    attributes :id, :params
    
    def call!
      user = User.find_by(id: id)  
      return Failure(:user_not_found , result: {msg: 'user not found!'}) unless user
      
      if user.update(params)
        return Success result: {user: user}
      end  
    end
  end
end