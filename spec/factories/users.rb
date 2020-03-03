FactoryBot.define do
  factory :user do
    uuid { "" }
    language { nil }
    agent { nil }
    ip_address { nil }
    primary_id { 1 }
    inviter_id { 1 }
    balance { 1 }
    super_user { false }
    banned { false }
    bot { false }
    deleted { false }
    consent { false }
    email_confirmed { false }
    phone_confirmed { false }
    allow_mail { false }
    foreign_slug { false }
    last_seen { "2020-02-24 23:35:11" }
    birthday { "2020-02-24" }
    slug { "MyString" }
    screen_name { "MyString" }
    password { "" }
    email { "MyString" }
    phone { "MyString" }
    image { "MyString" }
    notice { "MyString" }
    referral_link { "MyString" }
    data { "" }
  end
end
