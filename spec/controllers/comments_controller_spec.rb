require 'rails_helper'

RSpec.describe CommentsController, type: :controller do

sign_in_user
  let!(:user) { create(:user) }
  let(:answer) { create(:answer, question: question, user: create(:user)) }
  let!(:question) { create(:question, user: user) }
  
    context 'with valid attributes' do
      it 'creates and saves a new comment to a question to DB' do
        expect { post :create, params: { question_id: question.id, comment: attributes_for(:comment).merge(type: 'Question') }, format: :js }.to change(question.comments, :count).by(1)
      end

      it 'creates and saves a new comment to an answer to DB' do
        params = { answer_id: answer.id, comment: attributes_for(:comment).merge( type: 'Answer' ), format: :js }
        expect { post :create, params: params }.to change(answer.comments, :count).by(1)
      end
    end

    context 'with invalid attributes' do
      it 'fails to save a new comment to a question to DB' do
        expect { post :create, params: { question_id: question.id, comment: attributes_for(:invalid_comment).merge( type: 'Question' )}, format: :js  }.to_not change(question.comments, :count)
      end
      it 'fails to save a new comment to an answer to DB' do
        expect { post :create, params: { answer_id: answer.id, comment: attributes_for(:invalid_comment).merge( type: 'Answer' ), format: :js } }.to_not change(answer.comments, :count)
      end
    end

end
