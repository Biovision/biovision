# frozen_string_literal: true
require 'rails_helper'

RSpec.shared_examples_for 'has_unique_name' do
  let(:model) { described_class.to_s.underscore.to_sym }

  it 'is invalid with non-unique name' do
    create model, name: subject.name
    expect(subject).not_to be_valid
    expect(subject.errors.messages).to have_key(:name)
  end
end
