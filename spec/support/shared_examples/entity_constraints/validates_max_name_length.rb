# frozen_string_literal: true
require 'rails_helper'

# Model validates length of name attribute
RSpec.shared_examples_for 'validates_max_name_length' do |limit|
  describe 'validation' do
    it 'fails with too long name' do
      subject.name = 'A' * (limit.to_i + 1)
      expect(subject).not_to be_valid
      expect(subject.errors.messages).to have_key(:name)
    end

    it 'passes with name within limit' do
      subject.name = 'A' * limit
      expect(subject).to be_valid
    end
  end
end
