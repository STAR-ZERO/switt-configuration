require 'sinatra'
require 'sinatra/reloader' if development?
require 'logger'
require 'net/http'
require 'uri'
require 'json'

logger = Logger.new("#{settings.root}/tmp/logs/#{settings.environment}.log")

use Rack::Session::Cookie,
    secret: ENV['switt_session_secret'],
    expire_after: 86_400

CLIENT_ID = ENV['switt_client_id']
CLIENT_SECRET = ENV['switt_client_secret']

def redirect_uri
  URI.parse("#{request.scheme}://#{request.host}:#{request.port}/oauth_callback").to_s
end

get '/' do
  'Switt Configuration'
end

get '/login' do
  session[:return_to] = params[:return_to]
  url = "https://foursquare.com/oauth2/authenticate?client_id=#{CLIENT_ID}&response_type=code&redirect_uri=#{redirect_uri}"
  redirect to(url)
end

get '/oauth_callback' do

  code = params[:code]

  return_to = session[:return_to] || 'pebblejs://close#'

  begin
    unless code.nil?
      url = "https://foursquare.com/oauth2/access_token?client_id=#{CLIENT_ID}&client_secret=#{CLIENT_SECRET}&grant_type=authorization_code&redirect_uri=#{redirect_uri}&code=#{code}"
      json = Net::HTTP.get(URI.parse(url))
      result = JSON.parse(json)

      # see https://developer.pebble.com/guides/user-interfaces/app-configuration
      option = {oauth_token: result['access_token']}
      return_to += URI.escape(option.to_json, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))
    end
    redirect to(return_to)
  rescue => e
    logger.error e.message
  end
  redirect to(return_to)
end
