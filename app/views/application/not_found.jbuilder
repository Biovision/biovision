errors = [{code: 404, message: @message }]
json.errors do
  json.array! errors
end
