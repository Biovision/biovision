FactoryBot.define do
  factory :code do
    biovision_component { nil }
    user { nil }
    agent { nil }
    ip_address { nil }
    quantity { 1 }
    body { "MyString" }
    data { "" }
  end
end
