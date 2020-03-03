FactoryBot.define do
  factory :foreign_user do
    foreign_site { nil }
    user { nil }
    agent { nil }
    ip_address { nil }
    slug { "MyString" }
    data { "" }
  end
end
