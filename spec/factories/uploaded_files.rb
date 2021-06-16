FactoryBot.define do
  factory :uploaded_file do
    uuid { "" }
    biovision_component { nil }
    user { "" }
    ip_address { nil }
    agent { nil }
    attachment { "MyString" }
    data { "" }
  end
end
