FactoryBot.define do
  factory :login_attempt do
    user { nil }
    agent { nil }
    ip_address { nil }
    password { "MyString" }
  end
end
