json.extract! @user, :id
json.token @user.generate_jwt