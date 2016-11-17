class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_commentable

  def create
    @comment = @commentable.comments.build(comment_params.merge(author_id: current_user.id))

    if @comment.save
      flash[:success] = "Your comment successfully added"
    else
      flash[:danger] = "Your comment not added"
    end
  end

  private

  def set_commentable
    @commentable = Question.find(params[:question_id])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
