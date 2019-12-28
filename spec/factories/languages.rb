FactoryBot.define do
  factory :language do
    active { false }
    priority { 1 }
    slug { "MyString" }
    code { "MyString" }
  end
end
