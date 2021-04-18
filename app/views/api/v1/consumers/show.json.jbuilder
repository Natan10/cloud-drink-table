json.consumer do
  json.partial! "/api/partials/consumer", consumer: @consumer
  json.items do
    json.array! @consumer.items, partial: "/api/partials/item", as: :item
  end
end
