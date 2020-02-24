FactoryBot.define do
  factory :ip_address do
    ip { "" }
    object_count { 1 }
    banned { false }
  end
end
