class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_commentable, only: [:create, :new]
  before_action :load_comment, only: [:edit, :update, :destroy]

  after_action :post_comment, only: :create

  respond_to :js, :html

  def index
  end

  def new
  end

  def show
  end

  def create
    @commentable_id = [@commentable.class.name, @commentable.id.to_s].join('_')
    respond_with(@comment = @commentable.comments.create(comment_params.merge(user: current_user)))
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
      # json.comment = @comment
      ActionCable.server.broadcast(
        'comments_' + get_question_id.to_s, json)
    end

    def get_question_id
      if @commentable.class == Question
        @commentable.id
      elsif @commentable.class == Answer
        @commentable.question_id
      end
    end
end
