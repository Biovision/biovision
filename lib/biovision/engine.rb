# frozen_string_literal: true

# Biovision CMS
module Biovision
  # Engine class for Biovision CMS
  class Engine < ::Rails::Engine
    initializer 'biovision.load_base_methods' do
      ActiveSupport.on_load(:action_controller) do
        include Biovision::BaseMethods
      end
    end

    config.to_prepare do
      Dir.glob(Rails.root + 'app/decorators/**/*_decorator*.rb').each do |c|
        require_dependency(c)
      end
    end

    config.assets.precompile << %w[biovision_manifest.js]

    config.generators do |g|
      g.test_framework :rspec
      g.fixture_replacement :factory_bot, dir: 'spec/factories'
      g.factory_bot dir: 'spec/factories'
    end

    if defined?(FactoryBot)
      initializer 'biovision.factories', after: 'factory_bot.set_factory_paths' do
        FactoryBot.definition_file_paths << File.expand_path('../../../spec/factories', __FILE__)
      end
    end
  end

  require 'kaminari'
  require 'rails_i18n'
  require 'carrierwave'
  require 'mini_magick'
  require 'carrierwave-bombshelter'
  require 'image_optim'
  require 'rest-client'
end
