# your Twilio authentication credentials
ACCOUNT_SID = 'AC5cb9a6dcffb746ada26419b0b9621989'
ACCOUNT_TOKEN = '4ad536d882cdcf07f36876f264ee560d'

# version of the Twilio REST API to use
API_VERSION = '2010-04-01'

# base URL of this application
BASE_URL =  "http://quickstream.heroku.com/home" #production ex: "http://appname.heroku.com/callme"

# Outgoing Caller ID you have previously validated with Twilio
CALLER_ID = '949-272-0608'

class CallController < ApplicationController
  def call
  end
  
  def sms
    puts "RECEIVED A TEXT"
  end
end
