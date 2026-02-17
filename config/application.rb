require_relative "boot"

require "rails/all"
require "pagy"

Bundler.require(*Rails.groups)

module CourseManagement
  class Application < Rails::Application
    config.load_defaults 8.1

    config.autoload_lib(ignore: %w[assets tasks])


    config.autoload_paths << Rails.root.join("app/services")
  end
end
