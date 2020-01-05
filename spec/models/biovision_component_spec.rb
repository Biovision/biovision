# frozen_string_literal: true
require 'rails_helper'

RSpec.describe BiovisionComponent, type: :model do
  subject { build :biovision_component }

  it_behaves_like 'has_valid_factory'
  it_behaves_like 'requires_slug'
  it_behaves_like 'has_unique_slug'
  it_behaves_like 'has_incrementing_flat_priority'
end
