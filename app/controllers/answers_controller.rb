class AnswersController < ApplicationController
  include Votes
  before_action :authenticate_user!
  before_action :load_question, only: [:create,:new]
  before_action :load_answer, only: [:edit, :update, :destroy, :set_best]

  def edit
  end

  def new
    @answer = @question.answers.build
  end

  def create
    # respond_to :js
    # respond_with(@answer = @question.answers.create(answer_params))
    @answer = @question.answers.build(answer_params)
    @answer.user = current_user
    respond_to do |format|
      if @answer.save
        format.html { render partial: @answer , layout: false }
        format.js { render json: @answer, include: { attachments: { methods: :filename } }}
      else
        format.html { render text: @answer.errors.full_messages.join("\n"), status: :unprocessable_entity }
        format.js { render json: @answer.errors.full_messages, status: :unprocessable_entity }
      end
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
      # render json: { message: 'Your answer was successfully deleted.' }
    end
  end

  def set_best
    question = @answer.question
    if current_user.author_of? question
      @answer.set_best
      render json: { message: "You've set the best answer" }
    else
      render json: { message: "You're not allowed to set the best answer for this question" }
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
    params.require(:answer).permit(:body, attachments_attributes: [:id, :file, :_destroy])
  end

end