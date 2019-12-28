# frozen_string_literal: true
require 'rails_helper'

RSpec.shared_examples_for 'has_incrementing_flat_priority' do
  describe 'after initialize' do
    it 'increments priority' do
      subject.save
      expect(described_class.new.priority).to be > subject.priority
    end
  end
end
