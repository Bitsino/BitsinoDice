class BetsController < ApplicationController

  skip_before_action :authenticate_user_from_token!, only: :show

  def show
    @bet = Bet.find(params[:id])

    render layout: false
  end

  def create
    Rails.logger.error "!!!!!!!!!!!!!!!!!! - #{current_user.inspect}"
    bet             = current_user.bets.build(bet_attributes)
    bet.secret      = Secret.last || Secret.create
    bet.server_seed = session[:server_seed]
    bet.save

    respond_to do |format|
      format.json { render json: bet.to_json }
    end
  end

  protected

    def bet_attributes
      params.require(:bet).permit(:client_seed, :amount, :game, :multiplier, :rolltype)
    end

end