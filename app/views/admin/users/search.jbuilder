json.data @collection do |entity|
  json.partial! entity
end
json.partial! 'shared/pagination', locals: { collection: @collection }
