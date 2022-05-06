# frozen_string_literal: true

class GraphqlController < ApplicationController
  skip_forgery_protection

  def index
    render json: TweetCloneSchema.execute(params[:query], variables: params[:variables], context: {current_user: current_user} )
  end
end
