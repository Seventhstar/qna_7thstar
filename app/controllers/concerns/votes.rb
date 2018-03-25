module Votes
  extend ActiveSupport::Concern

  included do
    respond_to :json
    before_action :load_votable, only: [:vote_up, :vote_down, :reset]
    before_action :load_vote, only: [:reset]
  end

  def vote(value)
    if !current_user.author_of?(@votable) && !@votable.has_vote_by?(current_user)
      respond_with(@vote = @votable.votes.create({user: current_user, val: value})) do |format|
        format.json do
          render json: { vote: @vote.id, rating: @votable.rating }
        end
      end
    else
      render json: { error: "Author can't vote his question or answer." }, status: :unprocessable_entity
    end
  end  

  def vote_up
    vote(1)
  end

  def vote_down
    vote(-1)
  end

  def reset
   respond_with(@vote.destroy) do |format|
      format.json do
        render json: { vote: @vote.id, votable: @votable, rating: @votable.rating }
      end
    end
  end

  private
    def load_vote
      @vote = @votable.votes.where(user: current_user).first
    end

    def load_votable
      @votable = controller_name.classify.constantize.find(params[:id])
    end
end
