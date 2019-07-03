#
# Configuration object for storing some parameters required for making transactions
#
module Globalticket::Config
  class << self
    attr_accessor :api_key
    attr_accessor :api_secret
    attr_accessor :environment
    attr_accessor :verbose


    # Set's the default value's to nil and false
    # @return [Hash] configuration options
    def init!
      @defaults = {
        :@api_key   => nil,
        :@api_secret => nil,
        :@environment => 'test',
        :@verbose => false
      }
    end

    # Resets the value's to there previous value (instance_variable)
    # @return [Hash] configuration options
    def reset!
      @defaults.each { |key, value| instance_variable_set(key, value) }
    end

    # Set's the new value's as instance variables
    # @return [Hash] configuration options
    def update!
      @defaults.each do |key, value|
        instance_variable_set(key, value) unless instance_variable_defined?(key)
      end
    end
  end
  init!
  reset!
end
