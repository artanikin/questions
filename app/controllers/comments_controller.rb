class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_commentable

  after_action :publish_comment

  respond_to :json

  authorize_resource

  def create
    respond_with(@comment = @commentable.comments.create(comment_params.merge(author: current_user)))
  end

  private

  def set_commentable
    klass = [Question, Answer].detect { |obj| params["#{obj.name.underscore}_id"] }
    @commentable = klass.find(params["#{klass.name.underscore}_id"])
  end

  def publish_comment
    return if @comment.errors.any?
    ActionCable.server.broadcast(
      "comments_#{channel_id}",
      ApplicationController.render(json: {
        comment: @comment,
        commentable_type: @commentable.class.name.underscore,
        commentable_id: @commentable.id
      })
    )
  end

  def channel_id
    @commentable.is_a?(Question) ? @commentable.id : @commentable.question_id
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
