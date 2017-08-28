require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  sign_in_user
  let(:question) {create(:question)}
  let(:answer) {create(:answer,user: @user)}

  describe 'POST #create' do
    context 'with valid attributes' do

      it 'saves new answer to the DB' do
        expect {post :create, params: {question_id: question, answer: attributes_for(:answer)}}.to change(question.answers, :count).by(1)
      end

      it 'redirects to show view of a question' do
        post :create, params: {question_id: question, answer: attributes_for(:answer)}
        expect(response).to redirect_to question_path(question)
      end
    end

    context 'with invalid attributes' do
      it 'does not save new anwser to DB' do
        expect {post :create, params: {question_id: question, answer: attributes_for(:invalid_answer)}}.to_not change(Answer, :count)
      end

      it 're-renders new view' do
        post :create, params: {question_id: question, answer: attributes_for(:invalid_answer)}
        expect(response).to redirect_to question_path(question)
      end
    end
  end

  describe 'DELETE #destroy' do
    before {answer}

    context "user's answer" do
      it 'deletes answer' do
        expect {delete :destroy, params: {question_id: question, id: answer}}.to change(Answer, :count).by(-1)
      end

      it 'redirects to question' do
        delete :destroy, params: { question_id: question, id: answer }
        expect(response).to redirect_to question_path(answer.question)
      end

    end

    context 'user tries to delete foreign answer' do
      let!(:answer) { create(:answer, question: question) }

      it 'does not delete the answer' do
        expect { delete :destroy, params: { question_id: question, id: answer } }.to_not change(Answer, :count)
      end

      it 'redirects to question' do
        delete :destroy, params: { question_id: question, id: answer }
        expect { delete :destroy, params: { question_id: question, id: answer } }
      end
    end
  end
end


