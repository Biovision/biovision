# frozen_string_literal: true
require 'rails_helper'

RSpec.shared_examples_for 'requires_slug' do
  it 'is invalid without slug' do
    subject.slug = ''
    expect(subject).not_to be_valid
    expect(subject.errors.messages).to have_key(:slug)
  end
end
