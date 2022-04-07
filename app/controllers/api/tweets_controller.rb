# frozen_string_literal: true

module Api
  class TweetsController < ApplicationController
    def index
      render json: Tweet.all # ,include: ''
    end

    def show
      @tweet = Tweet.find(params[:id])
      render json: @tweet
    end

    def create
      @tweet = Tweet.new(tweet_params)

      if @tweet.save
        render json: @tweet, status: 200
      else
        render json: { errors: @tweet.errors.full_messages }, status: 500
      end
    end

    def update
      @tweet = Tweet.find(params[:id])

      if @tweet.update(tweet_params)
        render json: @tweet, status: 200
      else
        render json: { errors: @tweet.errors.full_messages }, status: 500
      end
    end

    def destroy
      @tweet = Tweet.find(params[:id])

      if @tweet.destroy
        render status: :ok, json: @tweet
      else
        render json: @tweet.errors.full_messages, status: 500
      end
    end

    private

    def tweet_params
      params.require(:tweet).permit(:user_id, :content)
    end
  end
end
