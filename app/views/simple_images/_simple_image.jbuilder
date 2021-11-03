json.id simple_image.uuid
json.type SimpleImage.table_name
json.attributes do
  json.call(simple_image, *SimpleImage.json_attributes)
end
json.meta do
  json.hd_url simple_image.image.hd_url
  json.large_url simple_image.image.large_url
  json.medium_url simple_image.image.medium_url
  json.small_url simple_image.image.small_url
  json.preview_url simple_image.image.preview_url
  json.tiny_url simple_image.image.tiny_url
end
