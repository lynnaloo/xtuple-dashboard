require 'google/api_client'
require 'google/api_client/auth/jwt_asserter'
require 'date'
require 'dotenv'

# Update these to match your own apps credentials
key_file = ENV['PRIVATE_KEY_PATH'] # File containing your private key
key_secret = ENV['PRIVATE_KEY_SECRET'] # Password to unlock private key
discovery_url ='/discovery/v1alpha1/apis/v1alpha1/rest'

# Initialize the client.
client = Google::APIClient.new(
  :application_name => ENV['APPLICATION_NAME'],
  :application_version => ENV['APPLICATION_VERSION'],
  :port => 8443,
  :host => ENV['DISCOVERY_HOST'],
  :discovery_path => discovery_url
)

# Load your credentials for the service account
key = Google::APIClient::KeyUtils.load_from_pkcs12(key_file, key_secret)
client.authorization = Signet::OAuth2::Client.new(
  :token_credential_uri => ENV['TOKEN_CREDENTIAL_URI'],
  :audience => ENV['AUDIENCE'],
  :scope => ENV['SCOPE'],
  :issuer => ENV['ISSUER'],
  :signing_key => key,
  :person => ENV['USERNAME']
)

# Start the scheduler
SCHEDULER.every '1m', :first_in => 0 do

  #puts client.authorization.grant_type

  # Request a token for our service account
  #client.authorization.fetch_access_token!

  # Initialize xTuple REST API. Note this will make a request to the
  # discovery service every time, so be sure to use serialization
  # in your production code. Check the samples for more details.
  #service = client.discovered_api('xtuple')

  # Start and end dates
  #startDate = DateTime.now.strftime("%Y-%m-01") # first day of current month
  #endDate = DateTime.now.strftime("%Y-%m-%d")  # now

  # Execute the query
  # contacts = client.execute(
  #   :api_method => service.dev.contacts.list,
  #   :parameters => {
  #     #'start-date' => startDate,
  #     #'end-date' => endDate,
  #     # 'sort' => "ga:month"
  # })

  # Update the dashboard
  # Note the trailing to_i - See: https://github.com/Shopify/dashing/issues/33
  #send_event('visitor_count',   { current: visitCount.data.rows[0][0].to_i })
  #puts contacts
  send_event('xtuple', {})
end
