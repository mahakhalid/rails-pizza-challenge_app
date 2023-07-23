# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Orders', type: :request do
  describe 'GET #index' do
    subject { response }
    # Note: state false is for incomplete order aka open orders
    let!(:order_1) do
      Order.create!(
        state: false,
        created_at: '2021-04-14T11:16:00Z',
        items: [{
          name: 'Tonno',
          size: 'Large',
          add: [],
          remove:[]
        }],
        promotion_codes: [],
        discount_code: nil
      )
    end

    let!(:order_2) do
      Order.create!(
        state: false,
        created_at: '2021-04-14T13:17:25Z',
        items: [{
          name: 'Margherita',
          size: 'Large',
          add: ["Onions", "Cheese", "Olives"],
          remove:[]
        },
        {
          name: 'Tonno',
          size: 'Medium',
          add: [],
          remove:["Onions", "Olives"]
        },
        {
          name: 'Margherita',
          size: 'Small',
          add: [],
          remove:[]
        }],
        promotion_codes: [],
        discount_code: nil
      )
    end

    let!(:order_3) do
      Order.create!(
        state: false,
        created_at: '2021-04-14T14:08:47Z',
        items: [{
          name: 'Salami',
          size: 'Medium',
          add: ["Onions"],
          remove:["Cheese"]
        },
        {
            name: 'Salami',
            size: 'Small',
            add: [],
            remove:[]
          },
          {
            name: 'Salami',
            size: 'Small',
            add: [],
            remove:[]
          },
          {
            name: 'Salami',
            size: 'Small',
            add: [],
            remove:[]
          },
          {
            name: 'Salami',
            size: 'Small',
            add: ["Olives"],
            remove:[]
          }],
        promotion_codes: ["2FOR1"],
        discount_code: ["SAVE5"]
      )
    end
  
    context 'correct response status' do
      it 'should return ok' do
        get root_path
        expect(response).to have_http_status(:ok)
      end
    end

    context 'renders corresponding index template' do
      it do
        get root_path
        should render_template('index') 
      end
    end
  
    context 'when all orders are open' do
      it 'should consist all to be displayed attributes of order as shown in data/orders.json file' do
        get root_path
        expect(response.body).to include('Orders')
        expect(response.body).to include('ID')
        expect(response.body).to include('Created')
        expect(response.body).to include('Items')
        expect(response.body).to include('Promotion Codes')
        expect(response.body).to include('Discount Codes')
        expect(response.body).to include('Tonno (Large)')
        expect(response.body).to include('Total Price: 10.40€')
        expect(response.body).to include('Total Price: 25.15€')
        expect(response.body).to include('Total Price: 16.29€')
        expect(response.body).to include('Orders')
      end

      it 'should count occurance of orders data and should be equal to 3' do
        get root_path
        expect(response.body.scan('ID').count).to eq(3)
        expect(response.body.scan('Created').count).to eq(3)
        expect(response.body.scan('Promotion Codes').count).to eq(3)
        expect(response.body.scan('Discount Codes').count).to eq(3)
        expect(response.body.scan('Items').count).to eq(3)
        expect(response.body.scan('Total Price').count).to eq(3)
      end
    end

    context 'If a user clicks on complete button for an order' do
      it 'should not be shown this order now' do
        order_1.update!(state: true)
        get root_path
        expect(response.body.scan('Total Price').count).to eq(2)
      end
    end

    context 'If a user clicks on all complete button for all order' do
      it 'should not show any orders now just the title Orders' do
        order_1.update!(state: true)
        order_2.update!(state: true)
        order_3.update!(state: true)
        get root_path
        expect(response.body).to include('Orders')
        expect(response.body.scan('ID').count).to eq(0)
        expect(response.body.scan('Created').count).to eq(0)
        expect(response.body.scan('Promotion Codes').count).to eq(0)
        expect(response.body.scan('Discount Codes').count).to eq(0)
        expect(response.body.scan('Items').count).to eq(0)
        expect(response.body.scan('Total Price').count).to eq(0)
      end
    end

  end

  describe 'PATCH #update' do
    subject { response }
    let!(:order) do
        Order.create!(
          state: false,
          created_at: '2021-04-14T11:16:00Z',
          items: [{
          name: 'Tonno',
          size: 'Large',
          add: [],
          remove:[]
        }],
          promotion_codes: [],
          discount_code: nil
        )
    end

    let(:params) { { order: { state: true } } }
   
    context 'updated order correctly and removes from orders view' do
      it 'redirects to root_path and removes that order' do
        patch order_path(order.id), params: params
        expect(response).to redirect_to(root_path)
        expect(response.body.scan('Total Price').count).to eq(0)
    end
  end
  end

end