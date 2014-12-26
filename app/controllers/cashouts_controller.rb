class CashoutsController < ApplicationController

  before_action :authenticate_user_from_token!, only: :show

  def create
    

    cashout = current_user.cashouts.build(cashout_attributes)
    
    # We deal in statoshis.
    cashout.amount = current_user.balance - ((cashout.amount * 100000000).to_i)
    # Take off miners fee.
    cashout.amount = cashout.amount - 10000
    
    if cashout.amount > 0 and Bitcoin::valid_address?(cashout.address)
      
      cashout.save
      
      bal = Balance.new
      bal.user_id = current_user.id
      bal.transaction_hash = "Cashout to " + cashout.address
      bal.amount = 0 - cashout.amount
      bal.save
      
    end

    respond_to do |format|
      format.html { redirect_to root_url }
      format.json { render json: co.to_json }
    end
  end

  protected

    def cashout_attributes
      params.require(:cashout).permit(:address, :amount)
    end
end