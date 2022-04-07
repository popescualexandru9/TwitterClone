# frozen_string_literal: true

module Api
  class UsersController < ApplicationController
    def index
      render json: User.all
    end

    def show
      @user = User.find(params[:id])
      render json: @user
    end

    def create
      @user = User.new(user_params)

      if @user.save
        render json: @user, status: 200
      else
        render json: @user.errors.full_messages, status: 500
      end
    end

    def update
      @user = User.find(params[:id])

      if @user.update(user_params)
        render json: @user, status: 200
      else
        render json: { errors: @user.errors.full_messages }, status: 500
      end
    end

    def destroy
      @user = User.find(params[:id])

      if @user.destroy
        render status: :ok, json: @user
      else
        render json: @user.errors.full_messages, status: 500
      end
    end

    def user_params
      params.require(:user).permit(:name, :handle, :bio, :email)
    end
  end
end
