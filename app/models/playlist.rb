class Playlist < ActiveRecord::Base
  belongs_to :facebook
  has_many :songs
end
