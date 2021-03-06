# frozen_string_literal: true

# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 20_220_429_121_312) do
  create_table 'friends', force: :cascade do |t|
    t.integer 'follower_id', null: false
    t.integer 'following_id', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['follower_id'], name: 'index_friends_on_follower_id'
    t.index ['following_id'], name: 'index_friends_on_following_id'
  end

  create_table 'likes', force: :cascade do |t|
    t.integer 'tweet_id'
    t.integer 'user_id'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['tweet_id'], name: 'index_likes_on_tweet_id'
    t.index ['user_id'], name: 'index_likes_on_user_id'
  end

  create_table 'tweets', force: :cascade do |t|
    t.integer 'user_id', null: false
    t.string 'content'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['user_id'], name: 'index_tweets_on_user_id'
  end

  create_table 'users', force: :cascade do |t|
    t.string 'name'
    t.string 'handle'
    t.text 'bio'
    t.string 'email'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.string 'password_digest'
  end

  add_foreign_key 'friends', 'users', column: 'follower_id'
  add_foreign_key 'friends', 'users', column: 'following_id'
  add_foreign_key 'tweets', 'users'
end
