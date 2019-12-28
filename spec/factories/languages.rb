# frozen_string_literal: true

FactoryBot.define do
  factory :language do
    code { SecureRandom.alphanumeric.gsub(/\d/, '').downcase[0..1] + '-' + SecureRandom.alphanumeric.gsub(/\d/, '').upcase[0..1] }
    sequence(:slug) { |n| "language#{n}" }
  end
end
