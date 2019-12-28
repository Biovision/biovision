# frozen_string_literal: true

# Biovision CMS
module Biovision
  # Engine class for Biovision CMS
  class Engine < ::Rails::Engine

    config.to_prepare do
      Dir.glob(Rails.root + 'app/decorators/**/*_decorator*.rb').each do |c|
        require_dependency(c)
      end
    end

    #config.assets.precompile << %w[biovision_manifest.js]

    config.generators do |g|
      g.test_framework :rspec
      g.fixture_replacement :factory_bot, dir: 'spec/factories'
      g.factory_bot dir: 'spec/factories'
    end

    initializer 'biovision.factories', after: 'factory_bot.set_factory_paths' do
      FactoryBot.definition_file_paths << File.expand_path('../../../spec/factories', __FILE__) if defined?(FactoryBot)
    end
  end

  require 'kaminari'
  require 'rails_i18n'
  require 'carrierwave'
  require 'mini_magick'
  require 'carrierwave-bombshelter'
  require 'rest-client'
end
