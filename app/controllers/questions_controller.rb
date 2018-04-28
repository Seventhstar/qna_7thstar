class QuestionsController < ApplicationController
  include Votes
  before_action :authenticate_user!, except: [:show, :index]
  before_action :load_question, only: [:show, :edit, :update, :destroy]
  after_action :post_question, only: :create
  before_action :build_comment, only: [:show]

  respond_to :html, :json

  def index
    respond_with(@questions = Question.all)
  end

  def show
    gon.question_id = @question.id
    gon.question_author_id = @question.user_id
    respond_with(@question)
  end

  def new
    respond_with(@question = Question.new)
  end

  def edit
  end

  def create
    respond_with(@question = current_user.questions.create(question_params))
  end

  def update
    if current_user.author_of?(@question)
      @question.update(question_params)
      respond_with(@question)
    end
  end

  def destroy
    if current_user.author_of?(@question)
      respond_with(@question.destroy!)
    end
  end

  private
    def build_comment
      @comment = @question.comments.build
    end

    def load_question
      @question = Question.find(params[:id])
    end
 
    def build_answer
      @answer = @question.answers.build
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
