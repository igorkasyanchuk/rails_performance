# frozen_string_literal: true

json.home root_url
json.users do
  json.array! @users, :id, :first_name, :age, :email
end
