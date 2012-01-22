class Facebook < ActiveRecord::Base
  validates_uniqueness_of :identifier
  validates_uniqueness_of :cell  
  has_many: playlists

  def profile
    @profile ||= FbGraph::User.me(self.access_token).fetch
  end

  def music
    @music ||= FbGraph::User.me(self.access_token).fetch.music
  end

  class << self
    extend ActiveSupport::Memoizable

    def config
      @config ||= if ENV['fb_client_id'] && ENV['fb_client_secret'] && ENV['fb_scope'] && ENV['fb_canvas_url']
        {
          :client_id     => ENV['fb_client_id'],
          :client_secret => ENV['fb_client_secret'],
          :scope         => ENV['fb_scope'],
          :canvas_url    => ENV['fb_canvas_url']
        }
      else
        YAML.load_file("#{Rails.root}/config/facebook.yml")[Rails.env].symbolize_keys
      end
    rescue Errno::ENOENT => e
      raise StandardError.new("config/facebook.yml could not be loaded.")
    end

    def app
      FbGraph::Application.new config[:client_id], :secret => config[:client_secret]
    end

    def auth(redirect_uri = nil)
      FbGraph::Auth.new config[:client_id], config[:client_secret], :redirect_uri => redirect_uri
    end

    def identify(fb_user)
      _fb_user_ = Facebook.find_or_initialize_by_identifier(fb_user.identifier.try(:to_s))
      _fb_user_.access_token = fb_user.access_token.access_token #why two access_token?
      #_fb_user_.name = fb_user.name
      # _fb_user_.is_friend_access = false
      _fb_user_.save!
      _fb_user_
    end
    
    def add_as_friend(fb_user, current_user)
      _fb_user_ = nil
      _fb_user_ = where(:identifier => fb_user.identifier.try(:to_s)).first
      if _fb_user_ == nil
        _fb_user_ = Facebook.new
        _fb_user_.identifier = fb_user.identifier.try(:to_s)
        _fb_user_.access_token = fb_user.access_token
        _fb_user_.is_friend_access = true
      end
      _fb_user_.name = fb_user.name
      _fb_user_.save!
      friends = current_user.friends #helps perf
      current_user.friends << _fb_user_ if !friends.include? _fb_user_
       _fb_user_    
    end
  end

end