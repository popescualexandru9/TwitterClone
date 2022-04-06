module Api
  class FriendsController < ApplicationController
    def index
      render json: Friend.all 
    end

    def show
      @friend = Friend.find(params[:id])
      render json: @friend
    end
  end
end