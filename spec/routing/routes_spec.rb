require 'rails_helper'

describe 'Routing', type: :routing do
  context 'Orders index route' do
    it 'takes to index route where all incomplete  orders are listed' do
      should route(:get, '/orders/index').to('orders#index')
    end
  end

  context 'Orders update route' do
    it 'takes to update route' do
      should route(:patch, '/orders/1').to(controller: :orders,action: :update, id: 1)
    end
  end

end