# frozen_string_literal: true

FactoryBot.define do
  factory :biovision_component do
    sequence(:slug) { |n| "component#{n}" }
  end
end
