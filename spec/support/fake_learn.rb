require 'sinatra/base'

class FakeLearn < Sinatra::Base
  set :show_exceptions, false
  set :raise_errors, true

  LEARN_DASHBOARD = 'Learn Dashboard'

  def self.sign_in(attributes = {})
    @@learn_user = {
      'admin' => false,
      'avatar_url' => 'https://gravat.ar/',
      'email' => 'user@example.com',
      'first_name' => 'Test',
      'has_active_subscription' => true,
      'id' => 1,
      'last_name' => 'User',
      'public_keys' => ['ssh-rsa abcdefg'],
      'username' => 'testuser'
    }.merge(attributes)
  end

  get '/oauth/authorize' do
    redirect_uri = URI.parse(params[:redirect_uri])
    state = params[:state]
    callback_url = redirect_uri.merge("?code=somecode&state=#{state}").to_s
    %{<a href="#{callback_url}">Authorize</a>}
  end

  post '/oauth/token' do
    content_type :json
    {
      'access_token' => 'e72e16c7e42f292c6912e7710c838347ae178b4a',
      'token_type' => 'bearer'
    }.to_json
  end

  get '/api/v1/me.json' do
    content_type :json
    { 'user' => @@learn_user }.to_json
  end

  get '/dashboard' do
    LEARN_DASHBOARD
  end
end

class HostMap
  def initialize(mappings)
    @mappings = mappings
  end

  def call(env)
    app_for(env['SERVER_NAME']).call(env)
  end

  private

  def app_for(server_name)
    @mappings[server_name] || NOT_FOUND
  end

  NOT_FOUND = lambda do |env|
    [
      404,
      { 'Content-Type' => 'text/html' },
      ["Unmapped server name: #{env['SERVER_NAME']}"]
    ]
  end
end

WebMock.disable_net_connect!

RSpec.configure do |config|
  config.before do
    FakeLearn.sign_in
    WebMock.
      stub_request(:any, %r{#{Regexp.escape(LEARN_URL)}.*}).
      to_rack(FakeLearn)
  end
end

Capybara.app = HostMap.new(
  'www.example.com' => Capybara.app,
  '127.0.0.1' => Capybara.app,
  URI.parse(LEARN_URL).host => FakeLearn
)
