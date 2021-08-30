json.restaurants do 
  json.array! @restaurants, partial: "/api/partials/restaurant", as: :restaurant
end


