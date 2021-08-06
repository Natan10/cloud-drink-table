json.user do 
  json.id @user.id
  json.username @user.username
  json.email @user.email
  if @user.photo.attached?
    json.photo rails_blob_path(@user.photo,only_path: true)
  end
end