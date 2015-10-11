require 'faraday'
require 'json'
require 'ostruct'
require 'oauth'

module BTCJam
  # Contains user authenticated API calls https://btcjam.com/faq/api
  class Users
    def self.get_client(access_token)
      id = ENV['BTCJAM_CLIENT_ID']
      secret = ENV['BTCJAM_CLIENT_SECRET']
      client = OAuth2::Client.new id, secret, site: 'https://btcjam.com'
      OAuth2::AccessToken.new client, access_token
    end

    def self.api_call(access_token, symbol, type)
      token = get_client access_token
      response = token.get("#{API_URL}/#{symbol}.json")

      if type == :object
        OpenStruct.new JSON.parse(response.body)
      elsif type == :array
        JSON.parse(response.body).collect { |i| OpenStruct.new i }
      end
    end

    def self.create(email, password)
      url = "#{API_URL}/"
      url += "users.json?appid=#{BTCJam.client_id}&secret=#{BTCJam.client_secret}"

      response = Faraday.post(url, email: email, password: password)

      JSON.parse(response.body)
    end

    def self.profile(access_token)
      api_call(access_token, :me, :object)
    end

    def self.open_listings(access_token)
      api_call(access_token, :my_open_listings, :array)
    end

    def self.receivables(access_token)
      OpenStruct.new api_call(access_token, :my_receivables, :object).user
    end

    def self.payables(access_token)
      OpenStruct.new api_call(access_token, :my_payables, :object).user
    end

    def self.identity_checks(access_token)
      api_call(access_token, :identity_checks, :object).identity_checks.collect do |i|
        OpenStruct.new i
      end
    end

    def self.addr_checks(access_token)
      api_call(access_token, :addr_checks, :object).addr_checks.collect do |i|
        OpenStruct.new i
      end
    end

    def self.credit_checks(access_token)
      api_call(access_token, :credit_checks, :object).credit_checks.collect do |i|
        OpenStruct.new i
      end
    end

    def self.automatic_plans(access_token)
      api_call(access_token, :automatic_plans, :object).automatic_plans.collect do |i|
        OpenStruct.new i
      end
    end
  end
end
