module Comments
  extend ActiveSupport::Concern

  included do
    before_action :load_comment, only: [:vote_up, :vote_down, :reset]
  end

  private
    def load_comment
      @commentable = controller_name.classify.constantize.find(params[:id])
    end
end
