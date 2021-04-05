FactoryBot.define do
  factory :group do
    uuid { "" }
    biovision_component { nil }
    parent_id { 1 }
    slug { "MyString" }
    name { "MyString" }
    description { "MyString" }
    parents_cache { "MyString" }
    children_cache { 1 }
  end
end
