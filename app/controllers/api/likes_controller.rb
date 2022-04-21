# frozen_string_literal: true

module Api
  class LikesController < ApplicationController
    protect_from_forgery with: :null_session

    def index
      render json: Like.where(tweet_id: params[:tweet_id])
    end

    def show
      @user = User.find_by(handle: params[:id])

      if @user
        @like = Like.where(tweet_id: params[:tweet_id], user_id: @user.id)
        render json: @like
      else
        # render status: :not_found
        raise ActiveRecord::RecordNotFound
      end
    end

    def create
      @like = Like.new(like_params)

      if @like.save
        render json: @like, status: 200
      else
        render json: { errors: @like.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def destroy
      @like = Like.find(params[:id])
      @like.destroy
      render status: :ok, json: @tweet
      # else
      #   render json: @like.errors.full_messages, status: 500
    end

    private

    def like_params
      params.require(:like).permit(:user_id).merge({ 'tweet_id' => params[:tweet_id] })
    end
  end
end
