# frozen_string_literal: true

Rails.application.routes.draw do
  # Below route is for PATCH request to update order
  resources :orders, only: [:update]
  # Below route takes to index (default landing page) to list all orders
  root 'orders#index'
end
