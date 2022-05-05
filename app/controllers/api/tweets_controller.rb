# frozen_string_literal: true

module Api
  class TweetsController < ApplicationController
    before_action :authorize_request
    
    def my
      render json: @current_user.tweets
    end

    def index
      render json: Tweet.all, include: ''
    end

    def show
      @tweet = Tweet.find(params[:id])
      render json: @tweet
    end

    def create
      @tweet = Tweet.new(tweet_params.merge(user_id: @current_user.id))

      if @tweet.save
        render json: @tweet, status: 200
      else
        render json: { errors: @tweet.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def update
      @tweet = Tweet.find(params[:id])

      if @tweet.update(tweet_params)
        render json: @tweet, status: 200
      else
        render json: { errors: @tweet.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def destroy
      @tweet = Tweet.find(params[:id])

      @tweet.destroy
      render status: :ok, json: @tweet
    end

    private

    def tweet_params
      params.require(:tweet).permit(:content)
    end
  end
end
