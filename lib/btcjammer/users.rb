require 'faraday'
require 'json'
require 'ostruct'
require 'oauth'

module BTCJammer
  # Contains user authenticated API calls https://btcjam.com/faq/api
  class Users
    def self.create(email, password)
      url = "#{API_URL}/"
      url += "users.json?appid=#{BTCJammer.client_id}&"
      url += "secret=#{BTCJammer.client_secret}"

      response = Faraday.post(url, email: email, password: password)

      JSON.parse(response.body)
    end

    def self.profile(access_token)
      BTCJammer.api_call(access_token, :me, :object)
    end

    def self.open_listings(access_token)
      BTCJammer.api_call(access_token, :my_open_listings, :array)
    end

    def self.receivables(access_token)
      OpenStruct.new BTCJammer.api_call(access_token, :my_receivables, :object).user
    end

    def self.payables(access_token)
      OpenStruct.new BTCJammer.api_call(access_token, :my_payables, :object).user
    end

    def self.identity_checks(access_token)
      BTCJammer.api_call(access_token, :identity_checks, :object)
        .identity_checks.collect do |i|
        OpenStruct.new i
      end
    end

    def self.addr_checks(access_token)
      BTCJammer.api_call(access_token, :addr_checks, :object).addr_checks.collect do |i|
        OpenStruct.new i
      end
    end

    def self.credit_checks(access_token)
      BTCJammer.api_call(access_token, :credit_checks, :object)
        .credit_checks.collect do |i|
        OpenStruct.new i
      end
    end

    def self.invest(access_token, listing_id, amount)
      token = BTCJammer.get_client access_token
      response = token.post("#{API_URL}/investments.json",
                            body: { listing_id: listing_id, amount: amount })

      investment = OpenStruct.new(JSON.parse(response.body)).listing_investment
      OpenStruct.new investment
    end

    def self.automatic_plans(access_token)
      BTCJammer.api_call(access_token, :automatic_plans, :object)
        .automatic_plans.collect do |i|
        OpenStruct.new i
      end
    end
  end
end
