json.id dynamic_page.id
json.type dynamic_page.class.table_name
json.attributes do
  json.call(dynamic_page, :slug, :url)
end
json.meta do
  json.text_for_link dynamic_page.text_for_link
  json.html(
    render(
      partial: 'admin/dynamic_pages/entity/in_search',
      locals: { entity: dynamic_page },
      formats: [:html]
    )
  )
end
json.links do
  json.self admin_dynamic_page_path(id: dynamic_page.id)
end
