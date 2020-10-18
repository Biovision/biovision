errors = [{code: 401, message: @message }]
json.errors do
  json.array! errors
end
