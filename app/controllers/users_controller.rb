require 'contexts/user'

class UsersController < ApplicationController

  skip_before_action :verify_authenticity_token
  before_filter      :authenticate, :except => [ :create, :create_multi, :sign_in ]

  def show
    render Context::Response.new(@current_user).perform
  end

  def update
    @current_user.update(user_param)
    return render Context::Response.new(@current_user.errors.messages, :user_invalid, :bad_request).perform unless @current_user.valid?
    render Context::Response.new(@current_user).perform
  end

  def create
    @current_user = User.new(user_param)
    return render Context::Response.new(@current_user.errors.messages, :user_invalid, :bad_request).perform unless @current_user.valid?
    @current_user.save
    render Context::Response.new(@current_user).perform
  end

  def create_multi
    data   = user_params.fetch(:users)
    users  = []
    errors = []

    data.each do |user|
      new_user = ::User.new(user)

      if new_user.valid?
        users << new_user
      else
        errors << user.merge!(error: new_user.errors.messages)
      end
    end

    return render Context::Response.new(errors, :user_invalid, :bad_request).perform if errors.present?
    User.import(users)
    render Context::Response.new({}).perform
  end

  def sign_in
    result = Context::User.sign_in(sign_in_param.dup)
    render result.perform
  end

  def sign_out
    result = Context::User.sign_out(@current_user)
    render result.perform

  end

  private

  def user_params
    params.permit(users: [:first_name, :last_name, :email, :password])
  end

  def user_param
    params.permit(:first_name, :last_name, :email, :password)
  end

  def sign_in_param
    params.permit(:email, :password)
  end

end
