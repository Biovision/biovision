FactoryBot.define do
  factory :role do
    uuid { "" }
    biovision_component { nil }
    user_count { 1 }
    slug { "MyString" }
    name { "MyString" }
    description { "MyString" }
  end
end
