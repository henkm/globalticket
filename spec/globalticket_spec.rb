require "spec_helper"

USER_ID = ENV["GLOBAL_TICKET_USER_ID"]

describe Globalticket do
  it "has a version number" do
    expect(Globalticket::VERSION).not_to be nil
  end

  it "initializes with API key and secret" do
    Globalticket::Config.api_key = "abc"
    Globalticket::Config.api_secret = "xyz"
  end

  it "sorts the attributes" do
    res = Globalticket::API.request_data({ z: 'last', a: 'first'})
    # puts res
    expect(res.to_a.first.first.to_s).to eq 'a'
  end

  it "returns default error message" do
    expect { Globalticket::API.get_available_users }.to raise_error("Invalid apiKey.")
  end


  describe "make api calls" do
    before(:all) do
      # set correct configuration
      Globalticket.set_credentials_from_environment
    end

    it "returns a list of users" do
      expect(Globalticket::API.get_available_users).to be_kind_of(Hash)
    end

    it "returns a list of ticket kinds" do
      expect(Globalticket::API.get_ticket_types(userId: 49)).to be_kind_of(Hash)
    end

    it "returns a list if available periods" do
      result = Globalticket::API.get_availability(userId: 49, start_date: Date.today)
      expect(result).to be_kind_of(Hash)
      # puts result
    end

    context "make a reservation" do

      before(:all) do
        @reservation_result = Globalticket::API.create_reservation(userId: 49, tickets: [{ticketTypeId: 58, ticketNumber: 1}], ticketDate: Time.now+(24*3600*8))
        @reservation_id = @reservation_result["reservationId"].to_i
      end

      it "Is a hash" do
        expect(@reservation_result).to be_kind_of(Hash)
      end

      it "returns a reservationId" do
        expect(@reservation_id).to be > 1
      end

      it "adds contact info to reservation" do
        result = Globalticket::API.add_contact(userId: 49, reservationId: @reservation_id, customerFirstName: "John", customerSurname: "Doe", customerEmailAddress: "test@example.com")
        expect(result).to be_kind_of(Hash)
      end

      it "adds completes reservation and receives barcodes" do
        result = Globalticket::API.complete_reservation(userId: 49, reservationId: @reservation_id)
        expect(result).to be_kind_of(Hash)
        expect(result["ticketBarcodes"].count).to eq 1
        expect(result["ticketBarcodes"].first["barcode"]).to be_kind_of(String)
      end

    end

  end
end
