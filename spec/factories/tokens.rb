FactoryBot.define do
  factory :token do
    user { nil }
    agent { nil }
    ip_address { nil }
    last_used { "2020-02-24 23:35:47" }
    sctive { false }
    token { "MyString" }
  end
end
