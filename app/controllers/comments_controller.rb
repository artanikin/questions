class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_commentable

  after_action :publish_comment

  def create
    @comment = @commentable.comments.build(comment_params.merge(author_id: current_user.id))

    if @comment.save
      message = "Your comment successfully added"
      render json: { comment: @comment, message: message }
    else
      message = "Your comment not added"
      render json: { errors: @comment.errors, message: message }, status: :unprocessable_entity
    end
  end

  private

  def set_commentable
    klass = [Question, Answer].detect { |obj| params["#{obj.name.underscore}_id"] }
    @commentable = klass.find(params["#{klass.name.underscore}_id"])
  end

  def publish_comment
    return if @comment.errors.any?
    ActionCable.server.broadcast(
      "comments_#{@commentable.id}",
      ApplicationController.render(json: {
        comment: @comment
      })
    )
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
