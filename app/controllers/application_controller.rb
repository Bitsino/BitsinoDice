class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :are_we_configured, :except => [:configure] 

  protected
  
  def are_we_configured
    if Figaro.env.master_public_keys == nil
      redirect_to configuration_path
    end
  end
end
