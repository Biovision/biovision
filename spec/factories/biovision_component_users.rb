FactoryBot.define do
  factory :biovision_component_user do
    biovision_component { nil }
    user { nil }
    administrator { false }
    data { "" }
  end
end
