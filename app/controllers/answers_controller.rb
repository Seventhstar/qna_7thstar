class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_question, only: [:create,:new]
  before_action :load_answer, only: [:edit, :update, :destroy, :set_best]

  def edit
  end

  def new
    @answer = @question.answers.build
  end

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    if @answer.save
    else
    end
  end

  def update
    @answer.update(answer_params)
    @question = @answer.question
  end


  def destroy
    @question = @answer.question
    if current_user.author_of? @answer
      @answer.destroy
      flash[:notice] = 'Your answer was successfully deleted.'
    end
  end

  def set_best
    question = @answer.question
    if current_user.author_of? question
      @answer.set_best
      @message = "You've set the best answer"
    end
    
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