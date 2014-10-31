class VisitorsController < ApplicationController

  def index
    session[:server_seed] = SecureRandom.hex(12)

    respond_to do |format|
      format.html do
        @bet  = Bet.new.tap do |b|
          b.server_seed = session[:server_seed]
          b.amount      = 0
          b.game        = 49.50
        end
        
        @cashout = Cashout.new
        
        @transactions = []

        @bets    = Bet.order('created_at DESC').limit(25)
        
        if current_user
          
          setup_transactions 
          
          make_sure_user_address_is_set
          
          last_bet = current_user.bets.last
          if last_bet != nil and last_bet.amount < (current_user.balance * 100000000)
            @bet.amount = last_bet.amount
          end
          
          @data_slider_range = "0," + current_user.balance.to_s
          
          @qr = RQRCode::QRCode.new(current_user.bitcoin_address)
        end
      end
      format.json do
        attrs = { server_seed: session[:server_seed] }
        attrs.merge!(auth_token: current_user.auth_token) if current_user
        
        render json: attrs
      end
    end
  end
  
  def make_sure_user_address_is_set
    if current_user.bitcoin_address == nil
      current_user.bitcoin_address = OnChain::Sweeper.multi_sig_address_from_mpks(
        ColdStorage.get_extended_keys, "m/#{current_user.id}")
      current_user.save
    end
  end
  
  def setup_transactions
    
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
  end
  
  # We get here if our ENV vars are not set.
  def configure
  end
  
end
