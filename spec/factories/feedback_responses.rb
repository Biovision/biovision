FactoryBot.define do
  factory :feedback_response do
    uuid { "" }
    feedback_message { nil }
    user { nil }
    agent { nil }
    ip_address { nil }
    body { "MyText" }
    data { "" }
  end
end
