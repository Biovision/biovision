json.id user.id
json.type user.class.table_name
json.attributes do
  json.call(user, :slug, :screen_name)
end
json.meta do
  json.text_for_link user.text_for_link
  json.html(
    render(
      partial: 'admin/users/entity/in_search',
      locals: { entity: user, skip_toggle: true },
      formats: [:html]
    )
  )
end
json.links do
  json.self admin_user_path(id: user.id)
end
