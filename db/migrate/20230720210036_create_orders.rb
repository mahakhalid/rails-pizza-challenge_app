# frozen_string_literal: true

class CreateOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :orders, id: :uuid do |t|
      t.boolean :state, default: false
      t.jsonb :items
      t.jsonb :promotion_codes
      t.string :discount_code
      t.timestamps
    end
  end
end
