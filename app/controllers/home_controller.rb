class HomeController < ApplicationController
  def index
  end

  def intro
  end

  #POST home/play
  def play
    # identifiers = params[:friend_tokens].split(",")
    # friend_list = current_user.friends.reject {|item| !identifiers.include? item.identifier}
    common_artist = Hash.new
    # friend_list.each do |friend|
    #   user = FbGraph::User.fetch(friend.identifier, :access_token => friend.access_token)
    #   user.music.each do |music|
    #     #if music.category == "Musician/band"
    #       if common_artist.has_key? music.name
    #         common_artist[music.name] += 1
    #       else
    #         common_artist[music.name] = 1
    #       end
    #     #end
    #   end  
    # end
    # 
    # current_user.music.each do |music|
    #   #if music.category == "Musician/band"
    #     if common_artist.has_key? music.name
    #       common_artist[music.name] += 1
    #     else
    #       common_artist[music.name] = 1
    #     end
    #   #end
    # end
    # 
    
    if (params[:query])
      common_artist[params[:query]] = 6
    
      sort_common_artists  = common_artist.sort_by {|key, values| -1*values}
      
      @playlist_title = params[:query]
            
      @tracklist = Array.new  
      counter = 0
      sort_common_artists.take(30).each do |pair|
        begin
          # c = Curl::Easy.perform("http://ws.spotify.com/search/1/track.json?q=#{CGI.escape pair[0].to_s}") # FROM SPOTIFY 
          c = Curl::Easy.perform("http://tinysong.com/s/#{CGI.escape pair[0].to_s.sub(" ","+")}?format=json&limit=#{[32,2**pair[1]-1].min}&key=186bd60f3a33be26da02d62d334bddf4") # FROM Tinysong      
        rescue
          next
        end
        parsed_json = ActiveSupport::JSON.decode(c.body_str)
        # parsed_json['tracks'].each do |track| # FOR SPOTIFY
        parsed_json.each do |track| # FOR TINYSONG
          # count = 0 # FOR SPOTIFY
          check = false
          @tracklist.each do |item|
            check = (item[0].downcase == track['SongName'].downcase)
            break if check
          end
          next if check
          # @tracklist << [track['name'], "http://open.spotify.com/track/" + track['href'][14..track['href'].length]] # FOR SPOTIFY
          @tracklist << [track['SongName'], track['ArtistName'], track['Url'], track['SongID']] # FOR TINYSONG
          counter += 1
          break if counter == 30
          # count += 1 # FOR SPOTIFY
          # break if count == 2**pair[1]-1 # FOR SPOTIFY
        end
        break if counter == 30
      end

      # @tracklist.each do |track| # FOR SPOTIFY
      #     begin
      #       c = Curl::Easy.perform("http://tinysong.com/b/#{CGI.escape track[0].to_s.sub(" ","+")}?format=json&key=186bd60f3a33be26da02d62d334bddf4") # FOR SPOTIFY
      #     rescue
      #       next
      #     end
      #   parsed_json = ActiveSupport::JSON.decode(c.body_str) # FOR SPOTIFY
      #   track << parsed_json['SongID'] # FOR SPOTIFY
      # end # FOR SPOTIFY
    else
      @tracklist = Array.new
      playlist = Playlist.find(params[:playlist_id].to_i)
      playlist.songs.each do |track| # FOR TINYSONG
        @tracklist << [track.name, track.artist, track.url, track.tinysong_id] # FOR TINYSONG
      end
      @playlist_title = playlist.name
      Curl::Easy.ssl_verify_peer = false
      c = Curl::Easy.http_post("https://graph.facebook.com/#{params[:user]}/quickstream:listen_to",
                               Curl::PostField.content('playlist', "http://quickstream.heroku.com/home/play?playlist_id=#{params[:playlist_id]}"),
                               Curl::PostField.content('access_token', 'AAAC3O7zjCaYBALJEKSRZCZAA4UbMDNksd0JRiMybumZCPfvum4dEduZCEw5JNH246lt9Atzqw4yddBhvJBIhQyf1rkSYTD0ZCrJYkoKWiU93UOkpCNnEZB'))
      
      puts "HEREEEE" + c.body_str                         
      
    end    
    
  	respond_to do |format|
       format.html # play.html.erb
    end

  end

end
