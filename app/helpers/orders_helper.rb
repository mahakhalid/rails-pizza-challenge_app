# frozen_string_literal: true

module OrdersHelper
  def id(order)
    order.id
  end

  def creation_date(order)
    order.created_at.to_formatted_s(:long)
  end

  def promotion_code(order)
    order.promotion_codes.any? ? order.promotion_codes.first : '-'
  end

  def discount_code(order)
    order.discount_code.present? ? order.discount_code : '-'
  end

  def pizza_name(item)
    item['name']
  end

  def pizza_size(item)
    item['size']
  end

  def add_ingredients?(item)
    item['add'].any?
  end

  def ingredients_to_add(item)
    'Add: ' + item['add'].join(', ')
  end

  def remove_ingredients?(item)
    item['remove'].any?
  end

  def ingredients_to_remove(item)
    'Remove: ' + item['remove'].join(', ')
  end
end
