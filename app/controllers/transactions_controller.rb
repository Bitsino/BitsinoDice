class TransactionsController < ApplicationController

  before_action :authenticate_user_from_token!

  def index
    @cashouts = current_user.cashouts.all
    respond_to do |format|
      format.html
      format.json { render :json => @cashouts }
    end
  end
end