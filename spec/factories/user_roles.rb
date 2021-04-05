FactoryBot.define do
  factory :user_role do
    user { nil }
    role { nil }
    inclusive { false }
  end
end
