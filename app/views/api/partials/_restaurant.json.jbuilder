json.id restaurant.id
json.name restaurant.name
if restaurant.logo.attached?
  json.photo rails_blob_path(restaurant.logo,only_path: true)
end

