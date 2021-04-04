FactoryBot.define do
  factory :contact_method do
    uuid { "" }
    language { nil }
    contact_type { nil }
    visible { false }
    priority { 1 }
    name { "MyString" }
    value { "MyString" }
    data { "" }
  end
end
