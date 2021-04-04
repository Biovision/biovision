FactoryBot.define do
  factory :feedback_message do
    uuid { "" }
    user { nil }
    ip_address { nil }
    agent { nil }
    processed { false }
    attachment { "MyString" }
    name { "MyString" }
    email { "MyString" }
    phone { "MyString" }
    comment { "MyText" }
    data { "" }
  end
end
