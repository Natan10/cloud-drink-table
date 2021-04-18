json.user do
  json.username @current_user.username
  json.email @current_user.email

  json.accounts do
    json.array! @accounts, partial: "/api/partials/account", as: :account
  end
end
