json.extract! room, :id, :name, :created_at, :updated_at
json.url account_room_url(room.account, room)
