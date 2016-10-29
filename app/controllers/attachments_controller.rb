class AttachmentsController < ApplicationController
  before_action :authenticate_user!

  def destroy
    @attachment = Attachment.find(params[:id])
    if current_user.author?(@attachment.attachable)
      @attachment.destroy
      flash.now[:notice] = 'File was deleted'
    else
      flash.now[:alert] = 'File not deleted'
    end
  end
end