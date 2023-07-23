# frozen_string_literal: true

class Order < ApplicationRecord

  def total_price
    order_price = base_price_with_ingredients
    order_price -= apply_promo_code if promo_code_applicable?
    order_price -= apply_discount_code(order_price) if discount_code_applicable?
    order_price.round(2)
  end

  private

  def base_price_with_ingredients
    base_price = 0
    items.each do |item|
      pizza_size = extract_data(item,'size_multipliers','size')
      pizza_type = extract_data(item,'pizzas','name')
      base_price += pizza_size * pizza_type
      add_ingredients = item['add'].present?
      if add_ingredients
        ingredients = item['add'].select { |ingredient| PRICE_CONFIG['ingredients'].select { |keys, values| keys.include?(ingredient) }.values }
        ingredients.each { |ingredient| base_price += PRICE_CONFIG['ingredients'][ingredient] * pizza_size }
      end
    end
    base_price
  end

  def promo_code_applicable?
    promotion_codes.present?
  end

  def apply_promo_code
    promo_code = PRICE_CONFIG['promotions']['2FOR1']
    percentage_off = promo_code['to'] / promo_code['from'].to_f
    target = promo_code['target']
    target_size = promo_code['target_size']
    target_count(target,target_size) * percentage_off * PRICE_CONFIG['size_multipliers'][target_size] * PRICE_CONFIG['pizzas'][target]
  end

  def discount_code_applicable?
    discount_code.present?
  end

  def apply_discount_code(intotal_price)
    intotal_price * (PRICE_CONFIG['discounts']['SAVE5']['deduction_in_percent'] / 100.to_f)
  end

  def target_count(target,target_size)
    items.count { |item| item['name'] == target && item['size'] == target_size }
  end

  def extract_data(item,config_key,item_key)
    PRICE_CONFIG[config_key].select { |keys, values| keys.include?(item[item_key]) }.values.first
  end

end
