FactoryBot.define do
  factory :foreign_site do
    slug { "MyString" }
    name { "MyString" }
    foreign_users_count { 1 }
  end
end
