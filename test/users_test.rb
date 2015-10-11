require './test/test_helper'

describe 'BTCJam::Users' do
  before do
    VCR.turn_off! ignore_cassettes: true
    BTCJam.configure do |config|
      config.client_id = 'test_id'
      config.client_secret = 'test_secret'
      config.redirect_uri = 'localhost/callback'
    end
  end

  after do
    VCR.turn_on!
  end

  it 'should exist for sure' do
    assert BTCJam::Users
  end

  it 'should support creating new users' do
    stub_request(:post, 'https://btcjam.com/api/v1/users.json?appid=test_id&secret=test_secret')
      .to_return(body: {}.to_json)

    BTCJam::Users.create('test@example.com', '12345')
  end

  it "should support retrieving an authenticated user's profile" do
    stub_request(:get, 'https://btcjam.com/api/v1/me.json')
      .to_return(body: { id: 123, email: 'test@example.com' }.to_json)

    token = '12345'
    profile = BTCJam::Users.profile token

    assert profile.id == 123
    assert profile.email == 'test@example.com'
  end

  it "should support retrieving an authenticated user's open listings" do
    stub_request(:get, 'https://btcjam.com/api/v1/my_open_listings.json')
      .to_return(body: [{ id: 123, title: 'Blarg' }].to_json)

    token = '12345'
    listings = BTCJam::Users.open_listings token

    assert listings.class == Array
    assert listings.first.id == 123
    assert listings.first.title == 'Blarg'
  end

  it "should support retrieving an authenticated user's recieables" do
    stub_request(:get, 'https://btcjam.com/api/v1/my_receivables.json')
      .to_return(body: { user: { id: 123, amount_received: 0.0 } }.to_json)

    token = '12345'
    receivables = BTCJam::Users.receivables token

    assert receivables.id == 123
    assert receivables.amount_received == 0.0
  end

  it "should support retrieving an authenticated user's payables" do
    stub_request(:get, 'https://btcjam.com/api/v1/my_payables.json')
      .to_return(body: { user: { id: 123, amount_paid: 0.0 } }.to_json)

    token = '12345'
    payables = BTCJam::Users.payables token

    assert payables.id == 123
    assert payables.amount_paid == 0.0
  end

  it "should support retrieving an authenticated user's identity checks" do
    stub_request(:get, 'https://btcjam.com/api/v1/identity_checks.json')
      .to_return(body: { identity_checks: [] }.to_json)

    token = '12345'
    identity_checks = BTCJam::Users.identity_checks token

    assert identity_checks.class == Array
  end

  it "should support retrieving an authenticated user's credit checks" do
    stub_request(:get, 'https://btcjam.com/api/v1/credit_checks.json')
      .to_return(body: { credit_checks: [] }.to_json)

    token = '12345'
    credit_checks = BTCJam::Users.credit_checks token

    assert credit_checks.class == Array
  end

  it "should support retrieving an authenticated user's address checks" do
    stub_request(:get, 'https://btcjam.com/api/v1/addr_checks.json')
      .to_return(body: { addr_checks: [] }.to_json)

    token = '12345'
    addr_checks = BTCJam::Users.addr_checks token

    assert addr_checks.class == Array
  end

  it "should support retrieving an authenticated user's automatic plans" do
    stub_request(:get, 'https://btcjam.com/api/v1/automatic_plans.json')
      .to_return(body: { automatic_plans: [] }.to_json)

    token = '12345'
    addr_checks = BTCJam::Users.automatic_plans token

    assert addr_checks.class == Array
  end
end
