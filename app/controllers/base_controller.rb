class BaseController < ApplicationController
  include SessionsHelper

  private

  def available_users
    User.where.not(id: @brand.user_ids).order(:email)
  end
end
