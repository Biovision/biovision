# frozen_string_literal: true

# Add checksum field to simple images
class AddChecksumToSimpleImages < ActiveRecord::Migration[6.1]
  def up
    # add_column :simple_images, :checksum, :string, index: true
    # SimpleImage.order(:id).each(&:save)
  end

  def down
    # remove_column :simple_images, :checksum
  end
end
