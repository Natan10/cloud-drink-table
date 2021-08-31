json.id restaurant.id
json.name restaurant.name
if restaurant.logo.attached?
  json.photo rails_blob_path(restaurant.logo,only_path: true)
end
json.products do 
  json.array! restaurant.products do |product|
    json.name product.name
    json.price humanized_money_with_symbol(product.price)
    json.description product.description
    if product.photo.attached?
      json.photo rails_blob_path(product.photo,only_path: true)
    end
  end
end

