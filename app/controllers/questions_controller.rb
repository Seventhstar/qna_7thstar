class QuestionsController < ApplicationController
  include Votes
  before_action :authenticate_user!, except: [:show, :index]
  before_action :load_question, only: [:show, :edit, :update, :destroy]

  after_action :post_question, only: :create

  def index
    @questions = Question.all
  end

  def show
    @commentable = @question
    @comment = Comment.new
    gon.question_id = @question.id
    gon.question_author_id = @question.user_id
  end

  def new
    @question = Question.new
    # @question.attachments.build
  end

  def edit

    # @question.attachments.build
  end

  def create
    @question = current_user.questions.new(question_params)
    if @question.save
      redirect_to @question
    else
      render :new
    end
  end

  def update
    if @question.update(question_params)
      redirect_to @question
    else
      flash[:notice] = 'error.'
      render :edit
    end
  end

  def destroy
    if current_user.author_of? @question
      @question.destroy
      flash[:notice] = 'Your question was successfully deleted.'
    end
    redirect_to questions_path
  end

  private
    def load_question
      @question = Question.find(params[:id])
    end

    def question_params
      params.require(:question).permit(:body, :title, attachments_attributes: [:id, :file, :_destroy])
    end

    def post_question
      return if @question.errors.any?
      ActionCable.server.broadcast(
        'questions', 
        @question.to_json(include: [:attachments, :user], methods: :rating))
    end
end
