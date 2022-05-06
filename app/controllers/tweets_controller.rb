# frozen_string_literal: true

class TweetsController < ApplicationController
  before_action :authorize_user

  def index
    @tweets = Tweet.all

    output = ''
    @tweets.each { |tweet| output += "#{tweet.inspect}\n" }
  end

  def show
    @tweet = Tweet.find(params[:id])

    render plain: @tweet.inspect
  end

  def new
    @tweet = Tweet.new
  end

  def create
    @tweet = Tweet.new(tweet_params)

    if @tweet.save
      redirect_to tweet_path
    else
      render :new, status: unprocessable_entity
    end
  end

  def edit
    @tweet = Tweet.find(params[:id])
  end

  def update
    @tweet = Tweet.find(params[:id])

    if @tweet.update(tweet)
      redirect_to edit_tweet_path
    else
      render :edit, status: unprocessable_entity
    end
  end

  def destroy
    @tweet = Tweet.find(params[:id])
    @tweet.destroy

    redirect_to tweet_path
  end

  private

  def tweet_params
    params.require(:tweet).permit(:content)
  end
end
