class AnswersController < ApplicationController
  include Votes
  before_action :authenticate_user!
  before_action :load_answer, only: [:edit, :update, :destroy, :set_best]
  before_action :load_question, except: [:vote_up, :vote_down, :reset]

  after_action :post_answer, only: :create

  authorize_resource

  respond_to :js
  respond_to :json, only: [:set_best]

  def edit
  end

  def new
    respond_with(@answer = @question.answers.build)
  end

  def create
    respond_with(@answer = @question.answers.create(answer_params.merge(user_id: current_user.id)))
  end

  def update
    if current_user.author_of?(@answer)
      @answer.update(answer_params)
      respond_with(@answer)
    end
  end


  def destroy
    if current_user.author_of?(@answer)
      respond_with(@answer.destroy)
    end
  end

  def set_best
    if current_user.author_of?(@question)
      respond_with(@answer.set_best)
    end
  end

  private

    def load_question
      @question = @answer ? @answer.question : Question.find(params[:question_id])
    end

    def load_answer
      @answer = Answer.find(params[:id])
    end

    def answer_params
      params.require(:answer).permit(:body, attachments_attributes: [:id, :file, :_destroy])
    end

    def post_answer
      return if @answer.errors.any?
      ActionCable.server.broadcast(
        "answers_#{@question.id.to_s}", 
        @answer.to_json(include: [:attachments, :user], methods: :rating))
    end

end