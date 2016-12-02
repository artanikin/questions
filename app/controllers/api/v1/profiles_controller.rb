class Api::V1::ProfilesController < ApplicationController
  before_action :doorkeeper_authorize!

  authorize_resource class: User

  respond_to :json

  def index
    render nothing: true
  end

  def me
    respond_with current_resource_owner
  end

  protected

  def current_resource_owner
    @curren_resource_owner ||= User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  end

  def current_ability
    @ability ||= Ability.new(current_resource_owner)
  end
end
