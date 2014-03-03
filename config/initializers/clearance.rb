Clearance.configure do |config|
  config.cookie_expiration = lambda { nil }
  config.mailer_sender = 'learn@thoughtbot.com'
end
