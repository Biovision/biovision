# frozen_string_literal: true

Rails.application.configure do
  config.i18n.enforce_available_locales = true
  config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}')]
  config.i18n.default_locale = :ru

  config.exceptions_app = routes

  overrides = "#{Rails.root}/app/overrides"
  Rails.autoloaders.main.ignore(overrides)
  config.to_prepare do
    Dir.glob("#{overrides}/**/*_override.rb").each do |override|
      load override
    end
  end
end
