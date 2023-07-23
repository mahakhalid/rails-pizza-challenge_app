# frozen_string_literal: true

class OrdersController < ApplicationController
  def index
    @orders = Order.where(state: false).order('created_at ASC')
    respond_to do |format|
      format.html
      format.json { render json: @orders }
    end
  end

  def update
    @order = Order.find(params[:id])
    @order.update(permitted_params)
    respond_to do |format|
      format.html do
        redirect_to root_path
      end
    end
  end

  private

  def permitted_params
    params.require(:order).permit(:state)
  end
end
