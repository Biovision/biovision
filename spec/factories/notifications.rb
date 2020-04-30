FactoryBot.define do
  factory :notification do
    uuid { "" }
    biovision_component { nil }
    user { nil }
    email_sent { false }
    read { false }
    data { "" }
  end
end
