# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Order, type: :model do
  describe 'attributes for Order' do
    it { is_expected.to have_db_column(:id).of_type(:uuid) }
    it { is_expected.to have_db_column(:state).of_type(:boolean).with_options(default: false) }
    it { is_expected.to have_db_column(:items).of_type(:jsonb) }
    it { is_expected.to have_db_column(:promotion_codes).of_type(:jsonb) }
    it { is_expected.to have_db_column(:discount_code).of_type(:string) }
    it { is_expected.to have_db_column(:created_at).of_type(:datetime).with_options(null: false) }
    it { is_expected.to have_db_column(:updated_at).of_type(:datetime).with_options(null: false) }
  end

  it 'has a valid factory' do
    expect(build(:order)).to be_valid
  end

  describe '#calculate total_price for order with no ingredients ,promo code or discount code' do

    context 'when order has only one item Tonno with size Small' do
      let(:order) { create(:order, items: [{ name: 'Tonno', size: 'Small' }]) }

      it 'returns correct base price' do
        expect(order.total_price).to eq(5.6)
      end
    end

    context 'when order has only one item Tonno with size Medium' do
      let(:order) { create(:order, items: [{ name: 'Tonno', size: 'Medium' }]) }

      it 'returns correct base price' do
        expect(order.total_price).to eq(8)
      end
    end

    context 'when order has only one item Tonno with size Large' do
      let(:order) { create(:order, items: [{ name: 'Tonno', size: 'Large' }]) }

      it 'returns correct base price' do
        expect(order.total_price).to eq(10.4)
      end
    end

    context 'when order has only one item Salami with size Small' do
      let(:order) { create(:order, items: [{ name: 'Salami', size: 'Small' }]) }

      it 'returns correct base price' do
        expect(order.total_price).to eq(4.2)
      end
    end

    context 'when order has only one item Salami with size Medium' do
      let(:order) { create(:order, items: [{ name: 'Salami', size: 'Medium' }]) }

      it 'returns correct base price' do
        expect(order.total_price).to eq(6)
      end
    end

    context 'when order has only one item Salami with size Large' do
      let(:order) { create(:order, items: [{ name: 'Salami', size: 'Large' }]) }

      it 'returns correct base price' do
        expect(order.total_price).to eq(7.8)
      end
    end

    context 'when order has only one item Margherita with size Small' do
      let(:order) { create(:order, items: [{ name: 'Margherita', size: 'Small' }]) }

      it 'returns correct base price' do
        expect(order.total_price).to eq(3.5)
      end
    end

    context 'when order has only one item Margherita with size Medium' do
      let(:order) { create(:order, items: [{ name: 'Margherita', size: 'Medium' }]) }

      it 'returns correct base price' do
        expect(order.total_price).to eq(5)
      end
    end

    context 'when order has only one item Margherita with size Large' do
      let(:order) { create(:order, items: [{ name: 'Margherita', size: 'Large' }]) }

      it 'returns correct base price' do
        expect(order.total_price).to eq(6.5)
      end
    end

    context 'when order has multiple items' do
      let(:order) { create(:order, items: [{ name: 'Tonno', size: 'Medium' }, {name: 'Margherita', size: 'Medium' }, {name: 'Salami', size: 'Medium' }]) }

      it 'returns correct base price' do
        expect(order.total_price).to eq(19)
      end
    end

  end

  describe '#calculate total_price for order with ingredients but no promo code or discount code' do

    context 'when order has only one item Margherita with size Large and ingredients to add' do
      let(:order) { create(:order, items: [{ name: 'Margherita', size: 'Large', add: ["Onions", "Cheese", "Olives"] }]) }

      it 'returns correct base price' do
        expect(order.total_price).to eq(13.65)
      end
    end

    context 'when order has only one item Margherita with size Large and ingredients to add and remove (Note: Removing ingredeints should not impact price)' do
      let(:order) { create(:order, items: [{ name: 'Margherita', size: 'Large', add: ["Onions", "Cheese"], remove: ["Olives"] }]) }

      it 'returns correct base price' do
        expect(order.total_price).to eq(10.4)
      end
    end

  end

  describe '#calculate total_price for order with discount code' do

    context 'when order has only one item Margherita with size Medium with 5 percent off' do
      let(:order) { create(:order, items: [{ name: 'Margherita', size: 'Medium'}],discount_code: "SAVE5") }

      it 'returns correct base price' do
        expect(order.total_price).to eq(4.75)
      end
    end

  end

  describe '#calculate total_price for order with promo code' do

    context 'when order has two Salami with size small on promo 2FOR1 for price of one' do
      let(:order) { create(:order, items: [{ name: 'Salami', size: 'Small'},{ name: 'Salami', size: 'Small'}], promotion_codes: "2FOR1") }

      it 'returns correct base price' do
        expect(order.total_price).to eq(4.2)
      end
    end

    context 'when order has four Salami with size small on promo 2FOR1 for price of two' do
      let(:order) { create(:order, items: [{ name: 'Salami', size: 'Small'},{ name: 'Salami', size: 'Small'},{ name: 'Salami', size: 'Small'},{ name: 'Salami', size: 'Small'}], promotion_codes: "2FOR1") }

      it 'returns correct base price' do
        expect(order.total_price).to eq(8.4)
      end
    end

    context 'when order has eight Salami with size small on promo 2FOR1 for price of four' do
      let(:order) { create(:order, items: [{ name: 'Salami', size: 'Small'},{ name: 'Salami', size: 'Small'},{ name: 'Salami', size: 'Small'},{ name: 'Salami', size: 'Small'},{ name: 'Salami', size: 'Small'},{ name: 'Salami', size: 'Small'},{ name: 'Salami', size: 'Small'},{ name: 'Salami', size: 'Small'}], promotion_codes: "2FOR1") }

      it 'returns correct base price' do
        expect(order.total_price).to eq(16.8)
      end
    end

  end

  describe '#calculate total_price for order with discount code and promo code' do

    context 'when order has two Salami with size small on promo 2FOR1 for price of one and discount SAVE5' do
      let(:order) { create(:order, items: [{ name: 'Margherita', size: 'Medium'},{ name: 'Salami', size: 'Small'},{ name: 'Salami', size: 'Small'}], promotion_codes: "2FOR1" ,discount_code: "SAVE5") }

      it 'returns correct base price' do
        expect(order.total_price).to eq(8.74)
      end
    end

  end

end