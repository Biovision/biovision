# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Language, type: :model do
  subject { build :language }

  it_behaves_like 'has_valid_factory'
  it_behaves_like 'has_incrementing_flat_priority'
  it_behaves_like 'has_unique_slug'
  it_behaves_like 'requires_slug'

  describe 'validation' do
    it 'fails without code' do
      subject.code = ''
      expect(subject).not_to be_valid
    end

    it 'fails with non-unique code' do
      subject.save!
      entity = build(:language, code: subject.code)
      expect(entity).not_to be_valid
    end

    it 'fails with too long code' do
      subject.code = 'a' * 9
      expect(subject).not_to be_valid
      expect(subject.errors.messages).to have_key(:code)
    end

    it 'fails with malformed code' do
      subject.code = 'Nope!'
      expect(subject).not_to be_valid
      expect(subject.errors.messages).to have_key(:code)
    end

    it 'fails with too long slug' do
      subject.slug = 'a' * 21
      expect(subject).not_to be_valid
      expect(subject.errors.messages).to have_key(:slug)
    end

    it 'fails with malformed slug' do
      subject.slug = 'Nope!'
      expect(subject).not_to be_valid
      expect(subject.errors.messages).to have_key(:slug)
    end
  end
end
