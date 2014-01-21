class CashoutsController < ApplicationController

  before_action :authenticate_user_from_token!, only: :show

  def create
    response = Cashout.perform(current_user.pkey, cashout_attributes[:address], amount)

    respond_to do |format|
      format.json do
        if response.code == 200
          render nothing: true
        else
          render json: JSON.parse(response.body), status: response.code
        end
      end
    end
  end

  protected

    def cashout_attributes
      params.permit(:address, :amount)
    end

    def amount
      if (current_user.balance.in_satoshi - 0.0005.in_satoshi) >= cashout_attributes[:amount].to_f.in_satoshi
        cashout_attributes[:amount].to_f.in_satoshi
      else
        current_user.balance.in_satoshi - 0.0005.in_satoshi
      end
    end
end