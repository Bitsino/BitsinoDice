require 'net/http'

class HomeController < ApplicationController

  def index
    session[:server_seed] = SecureRandom.hex(12)

    respond_to do |format|
      format.html do
        @bet  = Bet.new.tap do |b|
          b.server_seed = session[:server_seed]
          b.amount      = 0.00000000
          b.multiplier  = 2.0000
          b.game        = 49.50
        end

        @bets    = Bet.order('created_at DESC').limit(25).reverse
        
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
  
  def configure
    @cold_storage = ColdStorage.new
    
    render :layout => 'configure'
  end
  
  def configure_create

    @cold_storage = ColdStorage.new(master_public_key_params)
    
    rs = @cold_storage.redemption_script
    
    @cold_storage.fund_address = OnChain::Sweeper.generate_address_of_redemption_script(rs)
    
    if ColdStorage.count == 0
      respond_to do |format|
        if @cold_storage.save
          format.html { redirect_to root_path, notice: 'Configuration was successfully created.' }
        else
          format.html { render action: 'configure', :layout => 'configure' }
        end
      end
    end
    
  end


  private

    # Never trust parameters from the scary internet, only allow the white list through.
    def master_public_key_params
      params.require(:cold_storage).permit(:mpk)
    end
end