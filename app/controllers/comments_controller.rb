class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_commentable, only: [:create, :new]
  before_action :load_comment, only: [:edit, :update, :destroy]

  def index
  end

  def new
  end

  def create
    @comment = @commentable.comments.build(comment_params)
    @comment.user = current_user
    respond_to do |format|
      if @comment.save
        format.html { render partial: @comment , layout: false }
        format.js { render json: @comment }
      else
        format.html { render text: @comment.errors.full_messages.join("\n"), status: :unprocessable_entity }
        format.js { render json: @comment.errors.full_messages, status: :unprocessable_entity }
      end
    end
  end

  def update
    @comment.update(comment_params)
    @commentable = @comment.commentable
  end

  def destroy
    @commentable = @comment.commentable
    if current_user.author_of? @comment
      @comment.destroy
    end
  end

  private

    def load_commentable
      type = params.require(:comment).permit(:type).to_h[:type]
      id = params[(type.downcase+'_id').to_sym]
      @commentable = type.classify.constantize.find(id)
    end

    def load_comment
      @comment = Comment.find(params[:id])
    end

    def comment_params
      params.require(:comment).permit(:body)
    end
end
