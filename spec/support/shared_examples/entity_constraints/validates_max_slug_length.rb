# frozen_string_literal: true
require 'rails_helper'

# Model validates length of slug attribute
RSpec.shared_examples_for 'validates_max_slug_length' do |limit|
  describe 'validation' do
    it 'fails with too long slug' do
      subject.slug = 'a' * (limit.to_i + 1)
      expect(subject).not_to be_valid
      expect(subject.errors.messages).to have_key(:slug)
    end

    it 'passes with slug within limit' do
      subject.slug = 'a' * limit
      expect(subject).to be_valid
    end
  end
end
