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
    render json: {id: user.id, first_name: user.first_name, last_name: user.last_name}.to_json
  end

  def create
    user = User.new(user_param)

    user.save

    render json: {id: user.id}.to_json
  end

  private

  def user_param
    params.permit(:first_name, :last_name)
  end

end
