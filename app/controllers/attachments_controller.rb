class AttachmentsController < ApplicationController
  before_action :authenticate_user!

  def destroy
    @attachment = Attachment.find(params[:id])
    if current_user.author?(@attachment.attachable)
      @attachment.destroy
      flash.now[:success] = 'File was deleted'
    else
      flash.now[:danger] = 'File not deleted'
    end
  end
end
