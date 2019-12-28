FactoryBot.define do
  factory :metric do
    biovision_component { nil }
    incremental { false }
    start_with_zero { false }
    show_on_dashboars { false }
    default_period { 1 }
    value { 1 }
    previous_value { 1 }
    name { "MyString" }
  end
end
