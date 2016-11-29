require "application_responder"

class ApplicationController < ActionController::Base
  self.responder = ApplicationResponder
  respond_to :html

  protect_from_forgery with: :exception

  before_action :gon_user, unless: :devise_controller?

  check_authorization unless: :devise_controller?

  rescue_from CanCan::AccessDenied do |exсeption|
    redirect_to root_url, alert: exсeption.message
  end

  private

  def gon_user
    gon.user_id = current_user.id if current_user
  end
end
