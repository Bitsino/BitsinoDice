class BetsController < ApplicationController

  skip_before_action :authenticate_user_from_token!, only: :show

  def show
    @bet = Bet.find(params[:id])

    render layout: false
  end

  def create
    bet             = current_user.bets.build(bet_attributes)
    bet.secret      = Secret.last || Secret.create
    bet.server_seed = session[:server_seed]
    
    if bet.amount < 0
      bet.amount = 0
    end
    
    # Set limit to 1 BTC (100,000,000 satoshis).
    # Set limit to 0.2 BTC
    limit = 20000000
    if ENV['limit'] != nil
      limit = ENV['limit'].to_i
    end
    
    # We need to put a thread lock around this to stop timing attacks.
    if bet.amount <= current_user.balance and bet.amount < limit
      
      bet.save
      
      if ENV['PUSHER_URL'] != nil or ENV['pusher_url'] != nil
        Pusher['test_channel'].trigger('my_event', bet.as_json)
      end
    end

    respond_to do |format|
      format.html { redirect_to root_url }
      format.json { render json: bet.to_json }
    end
  end

  protected

    def bet_attributes
      params.require(:bet).permit(:client_seed, :amount, :game, :rolltype)
    end

end