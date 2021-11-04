json.extract! user, :id, :username, :email, :created_at, :updated_at
json.token user.generate_jwt