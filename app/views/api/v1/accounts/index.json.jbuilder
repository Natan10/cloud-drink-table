json.user do
  json.username user[:username]
  json.email user[:email]

  json.accounts do
    json.array! user[:accounts], partial: "/api/partials/account", as: :account
  end
end
