FactoryBot.define do
  factory :navigation_group_page do
    navigation_group { nil }
    dynamic_page { nil }
    priority { 1 }
  end
end
