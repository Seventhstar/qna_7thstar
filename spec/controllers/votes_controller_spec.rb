require 'rails_helper'

RSpec.describe VotesController, type: :controller do
  let!(:answer) { create(:answer) }
  let!(:vote) { create(:vote, votable: answer) }

  describe 'POST#create' do
    sign_in_user

    context 'with valid attributes' do
      it 'saves new Up vote to DB' do
        expect { post :create, params: { value: 1, votable_id: answer.id, votable_type: 'Answer' }, format: :js }.to change(Vote, :count).by(1)
      end

      it 'saves new Down vote to DB' do
        expect { post :create, params: { value: -1, votable_id: answer.id, votable_type: 'Answer' }, format: :js }.to change(Vote, :count).by(1)
      end
    end

    context 'with invalid attributes' do
      it 'fails to save new vote to DB' do
        expect { post :create, params: { value: 2, votable_id: answer.id, votable_type: 'Answer' }, format: :js }.not_to change(Vote, :count)
      end

      it 'fails to save second vote for user' do
        sign_in(vote.user)

        expect { post :create, params: { value: 1, votable_id: answer.id, votable_type: 'Answer' }, format: :js }.not_to change(Vote, :count)
      end

      it 'fails to save vote by votable author' do
        sign_in answer.user

        expect { post :create, params: { value: 1, votable_id: answer.id, votable_type: 'Answer' }, format: :js }.not_to change(Vote, :count)
      end
    end
  end

  describe 'DELETE#reset' do
    it 'deletes vote belonging to user' do
      sign_in(vote.user)

      expect { delete :reset, params: { votable_id: vote.votable_id, votable_type: vote.votable_type }, format: :js }.to change(vote.user.votes, :count).by(-1)
    end

    it "doesn't delete vote belonging to somebody else" do
      expect { delete :reset, params: { votable_id: vote.votable_id, votable_type: vote.votable_type }, format: :js }.not_to change(Vote, :count)
    end
  end
end
