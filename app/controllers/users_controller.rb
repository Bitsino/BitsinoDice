class UsersController < ApplicationController

  skip_before_filter :authenticate_user

  def create
    user = User.new(user_attributes)
    
    respond_to do |format|
      format.json do
        if user.save
          user.address = OnChain::Sweeper.multi_sig_address_from_mpks(
            ColdStorage.first.get_extended_keys, "m/#{user.id}")
          user.save
          sign_in user
          render json: user.to_json
        else
          render json: user.errors.full_messages.to_json, status: :unprocessable_entity
        end
      end
    end
  end

  protected

    def user_attributes
      params.permit(:username, :password)
    end

end