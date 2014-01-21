class SessionsController < ApplicationController
  def create
    user = User.find_for_database_authentication(username: params[:session][:username])

    if user && user.valid_password?(params[:session][:password])
      sign_in user
      render json: user.to_json, status: :created
    else
      render json: {
        errors: {
          email: "invalid email or password"
        }
      }, status: :unprocessable_entity
    end
  end

  def destroy
    sign_out :user
    render json: {}, status: :accepted
  end
end