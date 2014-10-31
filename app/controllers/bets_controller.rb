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
    
    # We need to put a thread lock around this to stop timing attacks.
    if bet.amount <= current_user.balance
      bet.save
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