json.id uploaded_file.uuid
json.type UploadedFile.table_name
json.attributes do
  json.call(uploaded_file, *UploadedFile.json_attributes)
end
json.links do
  json.attachment uploaded_file.attachment.url
end
