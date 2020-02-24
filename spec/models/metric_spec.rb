# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Metric, type: :model, focus: true do
  subject { build :metric }

  it_behaves_like 'has_valid_factory'
  it_behaves_like 'requires_name'
  it_behaves_like 'has_unique_name'
  it_behaves_like 'validates_max_name_length', Metric::NAME_LIMIT

  describe 'validation' do
    it 'fails without biovision_component' do
      subject.biovision_component = nil
      expect(subject).not_to be_valid
      expect(subject.errors.messages).to have_key(:biovision_component)
    end
  end

  describe 'before validation' do
    it 'normalizes period'
  end

  describe '#<<' do
    pending
  end

  describe '#register' do
    context 'when metric does not yet exist' do
      it 'creates new metric'
      it 'updates value'
    end

    context 'when metric exists' do
      it 'does not create new metric'
      it 'updates value'
    end
  end
end
