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

ActiveRecord::Schema.define(:version => 20121222182023) do

  create_table "broadcasters", :force => true do |t|
    t.string   "name"
    t.string   "logo_url"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "broadcasts", :force => true do |t|
    t.integer  "channel_id"
    t.string   "broadcaster_broadcast_id"
    t.datetime "start"
    t.datetime "end"
    t.string   "broadcaster_program_id"
    t.text     "synopsis"
    t.string   "title"
    t.string   "subtitle"
    t.string   "uuid"
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
  end

  create_table "channels", :force => true do |t|
    t.string   "name"
    t.string   "logo_url"
    t.string   "ingestion_url"
    t.string   "ingestion_module"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.integer  "broadcaster_id"
    t.string   "logo_file_name"
    t.string   "logo_content_type"
    t.integer  "logo_file_size"
    t.datetime "logo_updated_at"
  end

  create_table "search_limiters", :force => true do |t|
    t.string   "broadcast_uuid"
    t.datetime "last_external_request"
    t.datetime "last_internal_request"
    t.integer  "search_request_count"
    t.datetime "created_at",            :null => false
    t.datetime "updated_at",            :null => false
  end

  create_table "statuses", :force => true do |t|
    t.string   "broadcast_uuid"
    t.string   "text"
    t.string   "user"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "imei"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "uuid"
    t.string   "device_id"
    t.string   "os_version"
    t.integer  "api_level"
    t.string   "make"
    t.string   "model"
  end

end
