module Votes
  extend ActiveSupport::Concern

  included do
#    respond_to :json, only: [:vote_up, :vote_down, :reset]
    before_action :load_votable, only: [:vote_up, :vote_down, :reset]
  end

  def vote(value)
    respond_to do |format|
      format.json do
        if !current_user.author_of?(@votable) && !@votable.has_vote_by?(current_user)
          vote = @votable.votes.build({user: current_user, val: value})
          if vote.save 
            render json: { vote: vote.id, rating: @votable.rating }
          else
            render json: { error: vote.errors.full_messages  }, status: :unprocessable_entity
          end
        else
           render json: { error: "Author can't vote his question or answer." }, status: :unprocessable_entity
        end
      end
    end
  end  

  def vote_up
    vote(1)
  end

  def vote_down
    vote(-1)
  end

  def reset
    respond_to do |format|
      format.json do
        vote = @votable.votes.where(user: current_user).first
        if vote 
          vote.destroy
          render json: { vote: vote.id, votable: @votable, rating: @votable.rating }
        else
          render json: { error: 'Only the author of the vote can delete it.' }, status: :unprocessable_entity
        end
      end
    end
  end


  private
    def load_votable
      @votable = controller_name.classify.constantize.find(params[:id])
    end
end
