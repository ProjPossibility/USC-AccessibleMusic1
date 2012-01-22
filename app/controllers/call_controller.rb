require 'twilio-ruby'

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
  
  # {"AccountSid"=>"AC5cb9a6dcffb746ada26419b0b9621989", "Body"=>"test", "ToZip"=>"92677", "FromState"=>"CA", "ToCity"=>"LAGUNA NIGUEL", "SmsSid"=>"SM7ac62fadfde51b614605c1e830c9d395", "ToState"=>"CA", "To"=>"+19492720608", "ToCountry"=>"US", "FromCountry"=>"US", "SmsMessageSid"=>"SM7ac62fadfde51b614605c1e830c9d395", "ApiVersion"=>"2010-04-01", "FromCity"=>"IRVINE", "SmsStatus"=>"received", "From"=>"+19492664898", "FromZip"=>"92606", "controller"=>"call", "action"=>"sms"}
  def sms
    body = params["Body"].downcase.strip;
    number = params["From"];
    if body.match(/^play/)
      new_body = body.sub('play','').strip
      if new_body.match(/^playlist/)
        new_body = new_body.sub('playlist','').strip
        user = Facebook.find_by_cell(number)
        playlist = user.playlists.find_by_name(new_body)
        if playlist
          @body = "http://quickstream.heroku.com/home/play?playlist_id=#{CGI.escape playlist.id.to_s}"
        else
          @body = "Playlist does not exist!"
        end
      else
        @body = "http://quickstream.heroku.com/home/play?query=#{CGI.escape new_body}"
      end
    elsif body.match(/^create/)
      new_body = body.sub('create','').strip
      user = Facebook.find_by_cell(number)
      playlist = user.playlists.find_or_create_by_name(new_body)
      @body = "Playlist #{new_body} is Created!"
    elsif body.match(/^add/)
      new_body = body.sub('add','').strip
      new_body_array = new_body.split('to')
      song_title = new_body_array[0].strip
      playlist_title = new_body_array[1].strip
      user = Facebook.find_by_cell(number)
      playlist = user.playlists.find_or_create_by_name(playlist_title)
      song_json = get_song(song_title)
      song = playlist.songs.find_or_create_by_tinysong_id(song_json['SongID'].to_s)
      song.name = song_json['SongName']
      song.artist = song_json['ArtistName']
      song.url = song_json['Url']
      song.save!
      @body = "Song #{song_json['SongName']} was added to #{playlist_title}!"      
    end
    # @client = Twilio::REST::Client.new ACCOUNT_SID, ACCOUNT_TOKEN
    # @client.account.sms.messages.create(
    #   :from => "+19492720608",
    #   :to => number,
    #   :body => @body
    # )
  end
end


private
  def get_song(query)
    c = Curl::Easy.perform("http://tinysong.com/b/#{CGI.escape query.to_s.sub(" ","+")}?format=json&key=186bd60f3a33be26da02d62d334bddf4") # FROM Tinysong      
    parsed_json = ActiveSupport::JSON.decode(c.body_str)
    parsed_json    
  end