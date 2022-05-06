# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include SessionsHelper
  
  def index
  end

  def authorize_request
    header = request.headers['Authorization']
    header = header.split(' ').last if header
    begin
      @decoded = JsonWebToken.decode(header)
      @current_user = User.find(@decoded[:user_id])
    rescue ActiveRecord::RecordNotFound => e
      render json: { errors: e.message }, status: :unauthorized
    rescue JWT::DecodeError => e
      render json: { errors: e.message }, status: :unauthorized
    end
  end

  def authorize_user
    unless logged_in?
      session[:intended_url] = request.url  
      redirect_to login_url, alert: "Please log in first!"
    end
  end
end
