json.data do
  json.id entity.id
  json.type entity.class.table_name
  json.attributes do
    json.call(entity, :uuid, :description, :checksum, :object_count)
  end
  json.meta do
    json.name entity.name
    json.size number_to_human_size(entity.file_size)
    json.object_count t(:object_count, count: entity.object_count)
  end
  json.links do
    json.attachment entity.attachment.url
  end
end
