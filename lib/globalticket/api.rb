module Globalticket

  # The communication layer implements all the methods available in the Globalticket API
  # https://globalreseller.nl/documentation/
  class API
    require 'httparty'
    require 'date'

    ENDPOINT_PREFIX = "https://globalreseller.nl/webservices"

    # returns a list of available users
    def self.get_available_users
      self.make_api_call(endpoint: "getAvailableUsers", data: {})
    end

    # return a list of ticket types for given userId
    # Original documentation: https://globalreseller.nl/documentation/api/getTicketTypes
    def self.get_ticket_types(userId: nil, language: nil)
      self.make_api_call(endpoint: "getTicketTypes", data: {userId: userId.to_s, language: language})
    end

    # Fetch available periods and time slots
    # https://globalreseller.nl/documentation/api/getAvailability
    def self.get_availability(userId: nil, start_date: nil, end_date: nil)
      # set default dates if none are given
      start_date = Time.now if start_date.nil?
      end_date = start_date.to_time + ((3600 * 24) * 30) if end_date.nil? # add 31 days, max allowed

      # convert dates to required string
      start_date = self.convert_date_object_to_format(date: start_date, format: "%Y-%m-%d")
      end_date   = self.convert_date_object_to_format(date: end_date, format: "%Y-%m-%d")

      self.make_api_call(endpoint: "getAvailability", data: {userId: userId.to_s, startDate: start_date, endDate: end_date})
    end

    # Create a reservation
    # https://globalreseller.nl/documentation/api/createReservation
    def self.create_reservation(userId: nil, tickets: [], ticketDate: nil, ticketTime: nil)

      # convert dates to required string
      ticketDate = self.convert_date_object_to_format(date: ticketDate, format: "%Y-%m-%d") unless ticketDate.nil?
      ticketTime   = self.convert_date_object_to_format(date: ticketTime, format: "%H:%M") unless ticketTime.nil?

      self.make_api_call(endpoint: "createReservation", data: {userId: userId.to_s, tickets: tickets, ticketDate: ticketDate, ticketTime: ticketTime})
    end

    # Add a contact to a reservation
    # https://globalreseller.nl/documentation/api/addContact
    def self.add_contact(data = {})
      self.make_api_call(endpoint: "addContact", data: data)
    end

    # Complete a reservation
    # https://globalreseller.nl/documentation/api/completeReservation
    def self.complete_reservation(userId: nil, reservationId: nil)
      self.make_api_call(endpoint: "completeReservation", data: {userId: userId.to_s, reservationId: reservationId.to_s})
    end

    # Complete a reservation
    # https://globalreseller.nl/documentation/api/cancelReservation
    def self.cancel_reservation(userId: nil, reservationId: nil)
      self.make_api_call(endpoint: "cancelReservation", data: {userId: userId.to_s, reservationId: reservationId.to_s})
    end

    def self.convert_date_object_to_format(date: nil, format: "%Y-%m-%d")
      if date.is_a?(String)
        d = Date.parse(date)
      elsif date.is_a?(Date)
        d = date
      elsif date.is_a?(Time)
        d = date
      else
        raise "Invalid date. Should be of type Date, Time or String."
      end
      return d.strftime(format)
    end

    # return the request data as needed for the API
    # - sorted alphabetically
    # - ending with HMAC calculation
    def self.request_data(data)
      # delet data wit nil values
      data = data.select {|k, v| !v.nil? }

      # merge data with api-key and env
      unsorted_data = { apiKey: Config.api_key, environment: Config.environment }.merge(data)

      # sort alphabetically
      sorted_data = Hash[unsorted_data.sort_by{|k,v| k}]

      # calculate HMAC value
      calculated_hmac = Base64.encode64(OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha256'), Config.api_secret, sorted_data.to_json.strip)).strip.gsub("\n", "")

      request_data = sorted_data.merge({"HMACKey" => calculated_hmac})
      # puts request_data.to_json
      return request_data
    end

    # communicate with the API via POST requests and return the return
    # message in a ruby-esque manor.
    def self.make_api_call(endpoint: '', data: {})
      url = "#{ENDPOINT_PREFIX}/#{endpoint}"
      # puts "posting to URL: #{url}:\n#{self.request_data(data)}"
      result = JSON.parse(HTTParty.post(url,
                body: self.request_data(data).to_json,
                headers: { 'Accept' => 'application/json', 'Content-Type' => 'application/json' }).body)
      if result["success"] == false
        raise result["errorMessage"]
      else
        # puts result
        return result
      end
    end
  end
end
