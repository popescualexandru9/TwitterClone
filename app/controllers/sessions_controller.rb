# frozen_string_literal: true

class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user&.authenticate(params[:session][:password])
      log_in user
      flash[:alert] = "Welcome back, #{user.name}"
      redirect_to(session[:intended_url] || user)
      session[:intended_url] = nil
    else
      flash[:alert] = 'Invalid credentials'
      render 'new', status: :unprocessable_entity
    end
  end

  def destroy
    log_out
    redirect_to root_url
  end
end
