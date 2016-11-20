class AttachmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_attachment

  respond_to :js

  def destroy
    respond_with(@attachment.destroy) if current_user.author?(@attachment.attachable)
  end

  private

  def set_attachment
    @attachment = Attachment.find(params[:id])
  end
end
