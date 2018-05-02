class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_commentable, only: [:create, :new]
  before_action :load_comment, only: [:edit, :update, :destroy]
  after_action :post_comment, only: :create

  authorize_resource

  respond_to :js

  def create
    respond_with(@comment = @commentable.comments.create(comment_params.merge(user: current_user)))
  end

  def update                            
    @comment.update(comment_params)
    respond_with(@question)
  end

  def destroy
    respond_with(@comment.destroy)
  end

  private

    def load_commentable
      type = params.require(:comment).permit(:type, :body).to_h[:type]
      id = params[(type.downcase+'_id').to_sym]
      @commentable = type.classify.constantize.find(id)
    end

    def load_comment
      @comment = Comment.find(params[:id])
    end

    def comment_params
      params.require(:comment).permit(:body)
    end

    def post_comment
      return if @commentable.errors.any?
      json = @comment.to_json(include: [:attachments, :commentable, :user])
      ActionCable.server.broadcast("comments_#{@comment.question_id}", json)
    end

end
