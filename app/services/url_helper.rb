# Allows cleaner use of url helpers in models and service objects

class UrlHelper
  include Rails.application.routes.url_helpers

  def initialize(host: raise)
    default_url_options[:host] = host
  end
end
