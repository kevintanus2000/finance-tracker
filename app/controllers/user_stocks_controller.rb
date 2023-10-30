class UserStocksController < ApplicationController

  before_action :set_user_stock, only: %i[destroy]

  def create
    stock = Stock.check_db(params[:ticker])
    if !stock.present?
      stock = Stock.new_lookup(params[:ticker])
      stock.save
    end
    @user_stock = UserStock.create(user: current_user, stock: stock)
    flash[:notice] = "Stock #{stock.name} was successfully added to your portfololio"
    redirect_to my_portfolio_path
  end

  def destroy
    # @user_stock.destroy
    stock = Stock.find(params[:id])
    user_stock = UserStock.where(user_id: current_user.id, stock_id: stock.id)
    user_stock.destroy
    flash[:notice] = "#{stock.ticker} was successfully removed from portfololio"
    redirect_to my_portfolio_path
  end

  private

  def set_user_stock
    @user_stock = UserStock.find(params[:id])
  end

end
