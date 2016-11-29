class AttachmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_attachment

  respond_to :js

  authorize_resource

  def destroy
    respond_with(@attachment.destroy)
  end

  private

  def set_attachment
    @attachment = Attachment.find(params[:id])
  end
end
