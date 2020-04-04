FactoryBot.define do
  factory :simple_image do
    biovision_component { nil }
    user { nil }
    agent { nil }
    ip_address { nil }
    uuid { "" }
    object_count { 1 }
    image { "MyString" }
    image_alt_text { "MyString" }
    caption { "MyString" }
    source_name { "MyString" }
    source_link { "MyString" }
    data { "" }
  end
end
