FactoryBot.define do
  factory :dynamic_page do
    simple_image { nil }
    language { nil }
    visible { false }
    slug { "MyString" }
    url { "MyString" }
    name { "MyString" }
    body { "MyText" }
    data { "" }
  end
end
