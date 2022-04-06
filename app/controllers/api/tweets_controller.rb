module Api
  class TweetsController < ApplicationController
    def index
      render json: Tweet.all #,include: ''
    end

    def show
      @tweet = Tweet.find(params[:id])
      render json: @tweet
    end
  end
end