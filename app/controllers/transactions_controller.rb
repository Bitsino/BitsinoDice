class TransactionsController < ApplicationController

  before_action :authenticate_user_from_token!

  def index
    balances = current_user.balances.all
    
    @transactions = []
    
    balances.each do |balance|
      if ! balance.transaction_hash.start_with? "Bet"
        if ! balance.transaction_hash.start_with? "Cashout"
          tx = {}
          tx[:amount] = balance.amount / 100000000.0
          tx[:address] = "Deposit"
          tx[:status] = "Processed"
          tx[:date] = balance.created_at
          @transactions << tx
        else
          tx = {}
          tx[:amount] = balance.amount / 100000000.0
          tx[:address] = balance.transaction_hash
          tx[:status] = "Awaiting Signoff"
          tx[:date] = balance.created_at
          @transactions << tx
        end
      end
    end
    
    
    respond_to do |format|
      format.html
      format.json { render :json => @transactions }
    end
  end
end