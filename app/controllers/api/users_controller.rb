# frozen_string_literal: true

module Api
  class UsersController < ApplicationController
    before_action :authorize_request, except: :create

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
        render json: @user.errors.full_messages, status: :unprocessable_entity
      end
    end

    def update
      @user = User.find(params[:id])

      if @user.update(user_params)
        render json: @user, status: 200
      else
        render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def destroy
      @user = User.find(params[:id])

      render status: :ok, json: @user if @user.destroy
    end

    private

    def user_params
      params.require(:user).permit(:name, :handle, :bio, :email, :password, :password_confirmation)
    end
  end
end
