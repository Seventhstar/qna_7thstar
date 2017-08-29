class AnswersController < ApplicationController
  before_action :authenticate_user!, except: [:show, :index]
  before_action :load_question, only: [:create]
  before_action :load_answer, only: [:edit, :update, :destroy]

  def index
    @answers = @question.answers
  end

  def edit
  end

  def update
    @answer.update(answer_params)
    @question = @answer.question
  end

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    if @answer.save
      redirect_to question_path(@question)
    else
      # p "@answer #{@answer}",@answer.errors
      # flash[:alert] = @answer.errors.full_messages
      render 'questions/show'
    end
  end

  def destroy
    @question = @answer.question
    if current_user.author_of? @answer
      @answer.destroy
      flash[:notice] = 'Your answer was successfully deleted.'
    end
    redirect_to question_path(@question)
  end

  private

  def load_question
    @question = Question.find(params[:question_id])
  end

  def load_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end

end