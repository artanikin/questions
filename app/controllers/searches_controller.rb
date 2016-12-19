class SearchesController < ApplicationController
  authorize_resource class: Search

  respond_to :html

  def index
    respond_with @items = Search.search(params[:q], params[:object])
  end
end
