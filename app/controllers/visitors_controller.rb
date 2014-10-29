class VisitorsController < ApplicationController

  def index
    session[:server_seed] = SecureRandom.hex(12)

    respond_to do |format|
      format.html do
        @bet  = Bet.new.tap do |b|
          b.server_seed = session[:server_seed]
          b.amount      = 0
          b.multiplier  = 2
          b.game        = 49.50
        end

        @bets    = Bet.order('created_at DESC').limit(25)
        
        if current_user
          @transactions = Transaction.order('created_at DESC').limit(25)
        end
      end
      format.json do
        attrs = { server_seed: session[:server_seed] }
        attrs.merge!(auth_token: current_user.auth_token) if current_user
        
        render json: attrs
      end
    end
  end
  
end
