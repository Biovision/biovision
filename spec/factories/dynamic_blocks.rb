FactoryBot.define do
  factory :dynamic_block do
    visible { false }
    slug { "MyString" }
    name { "MyString" }
    body { "MyText" }
    data { "" }
  end
end
