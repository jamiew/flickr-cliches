# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20101002210306) do

  create_table "flickr_configs", :force => true do |t|
    t.string   "key"
    t.string   "secret"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "graphs", :force => true do |t|
    t.string   "graph_title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "photos", :force => true do |t|
    t.float    "lon"
    t.datetime "taken_at"
    t.datetime "updated_at"
    t.integer  "views"
    t.string   "owner_realname"
    t.float    "lat"
    t.string   "owner"
    t.integer  "owner_id"
    t.string   "photopage_url"
    t.datetime "created_at"
    t.integer  "tag_category_id"
    t.string   "flickr_id"
    t.string   "server"
  end

  create_table "photos_tags", :id => false, :force => true do |t|
    t.integer "photo_id"
    t.integer "tag_id"
  end

  create_table "tag_categories", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tags", :force => true do |t|
    t.string   "slug"
    t.string   "term"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "tag_category_id"
    t.boolean  "human_coded"
  end

end
