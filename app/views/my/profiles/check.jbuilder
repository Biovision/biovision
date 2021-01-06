json.meta do
  json.valid @registration_handler.valid?
  json.errors @registration_handler.user.errors
end
