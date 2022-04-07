# frozen_string_literal: true

class UsersController < ApplicationController
  def index
    @users = User.all

    output = ''
    @users.each { |user| output += "#{user.inspect}\n" }

    render plain: output
  end

  def show
    @user = User.find(params[:id])

    render plain: @user.inspect
  end

  def new
    @user = User.new(name: 'a', handle: 'adSsASsa', email: 'asddasasdsd')
  end

  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to user_path
    else
      render :new, status: unprocessable_entity
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])

    if @user.update(user_params)
      redirect_to edit_user_path
    else
      render :edit, status: unprocessable_entity
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy

    redirect_to users_path
  end

  def user_params
    params.require(:user).permit(:name, :handle, :bio, :email)
  end
end
