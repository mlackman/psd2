require 'httparty'
require 'yaml'


class LoginCommand

  def initialize(username, password, consumer_key)
    @url = 'https://psd2-api.openbankproject.com/my/logins/direct'
    @headers = {"Content-Type" => "application/json",
                "Authorization" => "DirectLogin username=\"#{username}\", password=\"#{password}\", consumer_key=\"#{consumer_key}\""}
  end

  def execute
    response = HTTParty.post(@url, headers: @headers)
    return response.parsed_response
  end

end

class GetAccountCommand

  def initialize(bank_id, account_id, token)
    @url = "https://psd2-api.openbankproject.com/obp/v3.0.0/my/banks/#{bank_id}/accounts/#{account_id}/account"
    @headers = { "Content-Type" => "application/json", "Authorization" => "DirectLogin token=\"#{token}\""}
  end

  def execute
    response = HTTParty.get(@url, headers: @headers)
    response.parsed_response
  end

end

class GetTransactionsCommand

  def initialize(bank_id, account_id, token)
    @url = "https://psd2-api.openbankproject.com/obp/v3.0.0/my/banks/#{bank_id}/accounts/#{account_id}/transactions"
    @headers = { "Content-Type" => "application/json", "Authorization" => "DirectLogin token=\"#{token}\""}
  end

  def execute
    response = HTTParty.get(@url, headers: @headers)
    response.parsed_response
  end

end

credentials = YAML.load(File.read('credentials.secret.yaml'))

login = LoginCommand.new(credentials['username'], credentials['password'], credentials['customer_secret'])
token = login.execute()['token']

account_id = 'deadbeef'
bank_id = 'psd201-bank-x--uk'
#response = GetAccountCommand.new(bank_id, account_id, token).execute
response = GetTransactionsCommand.new(bank_id, account_id, token).execute
p response

