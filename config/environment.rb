# Load the Rails application.
require_relative 'application'

# Initialize the Rails application.
Rails.application.initialize!
require 'rest-client'
require 'json'
response = RestClient.get "https://mailtrap.io/api/v1/inboxes.json?api_token=#{ENV['MAILTRAP_API_TOKEN']}"
first_inbox = JSON.parse(response)[0] # get first inbox

ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings = {
  :user_name => first_inbox['username'],
  :password => first_inbox['password'],
  :address => first_inbox['domain'],
  :domain => first_inbox['domain'],
  :port => first_inbox['smtp_ports'][0],
  :authentication => :plain
}