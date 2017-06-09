require "globalticket/version"
require "globalticket/config"
require "globalticket/engine" if defined?(Rails) && Rails::VERSION::MAJOR.to_i >= 3
require "globalticket/api"

module Globalticket
  # Your code goes here...

  # For testing purpose only: set the username and password
  # in environment variables to make the tests pass with your test
  # credentials.
  def self.set_credentials_from_environment
    Config.api_key = ENV["GLOBAL_TICKET_API_KEY"]
    Config.api_secret = ENV["GLOBAL_TICKET_API_SECRET"]

  end
end
