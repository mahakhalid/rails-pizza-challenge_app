# frozen_string_literal: true

# Order.destroy_all is run to destroy all orders to have a clean state as "rails db:seed" command can be run mutliple times resulting in duplicate data
# Alternatively, this can also be achieved using a rake task
Order.destroy_all
orders = JSON.parse(File.read('data/orders.json'))

orders.each do |order|
  order['state'].downcase!
  formatted_data = order.transform_keys(&:underscore)
  Order.create(formatted_data)
end
