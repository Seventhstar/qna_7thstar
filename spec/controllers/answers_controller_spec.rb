require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  sign_in_user
  let(:question) {create(:question)}
  let(:answer) {create(:answer, user: @user)}

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
        expect(response).to render_template 'questions/show'
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:answer) {create(:answer)}

    context "user's answer" do
      it 'deletes answer' do
        sign_in(answer.user)
        expect {delete :destroy, params: {question_id: answer.question_id, id: answer}}.to change(answer.user.answers, :count).by(-1)
      end

      it 'redirects to question' do
        sign_in(answer.user)
        question = answer.question
        delete :destroy, params: {question_id: question, id: answer}
        expect(response).to redirect_to question_path(answer.question)
      end

    end

    context 'user tries to delete foreign answer' do
      it "doesn't delete foreign answer" do
        expect {delete :destroy, params: {id: answer, question_id: answer.question_id}}.not_to change(Answer, :count)
      end

    end
  end
end


