class CashoutsController < ApplicationController

  before_action :authenticate_user_from_token!, only: :show

  def create
    
    #if amount > 0
      co = Cashout.new
      co.user_id = current_user.id
      co.address = cashout_attributes[:address]
      co.amount = amount
      co.save
      #end

    respond_to do |format|
      format.json { render json: co.to_json }
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