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

ActiveRecord::Schema.define(:version => 20121206231333) do

  create_table "happiness_entries", :force => true do |t|
    t.integer  "uid"
    t.date     "entry_date"
    t.time     "entry_time"
    t.integer  "happiness_value"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "happiness_entries", ["entry_date"], :name => "index_happiness_entries_on_entry_date"
  add_index "happiness_entries", ["entry_time"], :name => "index_happiness_entries_on_entry_time"
  add_index "happiness_entries", ["happiness_value"], :name => "index_happiness_entries_on_happiness_value"
  add_index "happiness_entries", ["uid"], :name => "index_happiness_entries_on_uid"

  create_table "metric_types", :force => true do |t|
    t.string   "title"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "uid"
    t.integer  "position"
  end

  create_table "metric_types_metrics", :force => true do |t|
    t.integer "metric_id"
    t.integer "metric_type_id"
  end

  add_index "metric_types_metrics", ["metric_id"], :name => "index_metric_types_metrics_on_metric_id"
  add_index "metric_types_metrics", ["metric_type_id"], :name => "index_metric_types_metrics_on_metric_type_id"

  create_table "metric_values", :force => true do |t|
    t.string   "uid"
    t.text     "description"
    t.float    "value"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.string   "metric_type"
    t.integer  "metric_id"
  end

  add_index "metric_values", ["metric_type"], :name => "index_metric_values_on_metric_type"
  add_index "metric_values", ["uid"], :name => "index_metric_values_on_uid"
  add_index "metric_values", ["value"], :name => "index_metric_values_on_value"

  create_table "metrics", :force => true do |t|
    t.string   "title"
    t.text     "description",   :limit => 255
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
    t.integer  "metric_type"
    t.integer  "metric_format"
  end

end
