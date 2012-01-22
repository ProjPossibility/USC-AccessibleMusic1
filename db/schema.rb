# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120122032434) do

  create_table "facebooks", :force => true do |t|
    t.string   "identifier"
    t.string   "access_token"
    t.string   "cell"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "facebooks", ["identifier"], :name => "index_facebooks_on_identifier", :unique => true

  create_table "playlists", :force => true do |t|
    t.string   "name"
    t.integer  "facebook_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "playlists", ["facebook_id"], :name => "index_playlists_on_facebook_id"

  create_table "songs", :force => true do |t|
    t.string   "tinysong_id"
    t.integer  "playlist_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "songs", ["playlist_id"], :name => "index_songs_on_playlist_id"

end
