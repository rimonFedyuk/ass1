class UsersController < ApplicationController

  skip_before_action :verify_authenticity_token

  def show
    user = User.find_by(id: params[:id])

    unless user
      render json: {message: 'user not found', error: :user_not_found}, status: :not_found
      return
    end

    render json: {id: user.id, first_name: user.first_name, last_name: user.last_name}.to_json
  end

  def update
    user = User.find_by(id: params[:id])

    unless user
      render json: {message: 'user not found', error: :user_not_found}, status: :not_found
      return
    end

    user.update(user_param)

    unless user.valid?
      render json: {message: user.errors.messages, error: :user_invalid}, status: :bad_request
      return
    end

    render json: {id: user.id, first_name: user.first_name, last_name: user.last_name}.to_json
  end

  def create
    user = User.new(user_param)

    unless user.valid?
      render json: {message: user.errors.messages, error: :user_invalid}, status: :bad_request
      return
    end

    user.save

    render json: {id: user.id}.to_json
  end

  def create_multi

    data = user_params[:users]

    users = []
    errors = []

    data.each { |user|
      new_user = User.new(user)

      unless new_user.valid?
        user[:error] = new_user.errors.messages
        errors << user
      end

      users << new_user
    }

    if errors.length > 0
      render json: {messages: errors, error: :user_invalid}, status: :bad_request
      return
    end

    User.import(users)

    render json: {}, status: :ok
  end

  private

  def user_params
    params.permit(users: [:first_name, :last_name])
  end

  def user_param
    params.permit(:first_name, :last_name)
  end

end
