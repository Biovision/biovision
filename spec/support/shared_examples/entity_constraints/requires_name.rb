# frozen_string_literal: true
require 'rails_helper'

RSpec.shared_examples_for 'requires_name' do
  it 'is invalid without name' do
    subject.name = ''
    expect(subject).not_to be_valid
    expect(subject.errors.messages).to have_key(:name)
  end
end
