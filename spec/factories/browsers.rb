FactoryBot.define do
  factory :browser do
    mobile { false }
    name { "MyString" }
    version { "MyString" }
    user_agents_count { 1 }
  end
end
