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

        @bets    = Bet.order('created_at DESC').limit(25)
        
        if current_user
          
          if current_user.bitcoin_address == nil
            current_user.bitcoin_address = OnChain::Sweeper.multi_sig_address_from_mpks(
              ColdStorage.get_extended_keys, "m/#{current_user.id}")
            current_user.save
          end
          
          @transactions = Transaction.order('created_at DESC').limit(25)
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
  
  # We get here if our ENV vars are not set.
  def configure
  end
  
end
