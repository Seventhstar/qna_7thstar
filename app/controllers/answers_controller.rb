class AnswersController < ApplicationController
  before_action :load_question, only: [:create, :index, :new]
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
    if @answer.save
    	redirect_to question_path(@question)
    else
      render 'questions/show'
    end
  end

  def destroy
    @question = @answer.question
    @answer.destroy
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