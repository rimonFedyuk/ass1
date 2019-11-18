require 'contexts/response'

module Context
  module User
    extend self

    def sign_in(opts)
      @current_user = ActiveRecord::Base::User.find_by(email: opts.fetch(:email))

      return Context::Response.new('user not found', :user_not_found, :not_found) unless @current_user
      return Context::Response.new('invalid password', :invalid_password, :forbidden) unless validate_user_password(opts.fetch(:password))

      @current_user.update({:current_session_token => generate_token})

      Context::Response.new(@current_user)
    end

    def sign_out(current_user)
      current_user.update({:current_session_token => ''})
      Context::Response.new({})
    end

    def validate_user_password(password)
      @current_user.password_hash(password) == @current_user.password_digest
    end

    def generate_token
      SecureRandom.hex(32)
    end

  end
end