# frozen_string_literal: true

FactoryBot.define do
  factory :metric do
    biovision_component
    sequence(:name) { |n| "test.metric#{n}.hit" }
  end
end
