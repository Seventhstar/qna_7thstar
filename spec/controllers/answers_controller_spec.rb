require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  sign_in_user
  let(:question) {create(:question)}
  let(:answer) {create(:answer, user: @user)}


  describe 'GET #new' do
    before do
      get :new, params: { question_id: question.id }
    end

    it 'assigns new Answer to @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do

      it 'saves new answer to the DB' do
        expect {post :create, params: {question_id: question, answer: attributes_for(:answer), format: :js}}.to change(question.answers, :count).by(1)
      end

      it 'redirects to show view of a question' do
        post :create, params: {question_id: question, answer: attributes_for(:answer), format: :js}
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      it 'does not save new anwser to DB' do
        expect {post :create, params: {question_id: question, answer: attributes_for(:invalid_answer), format: :js}}.to_not change(Answer, :count)
      end

      it 're-renders new view' do
        post :create, params: {question_id: question, answer: attributes_for(:invalid_answer), format: :js}
        expect(response).to render_template :create
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
      sign_in_user
      it "doesn't delete foreign answer" do
        expect {delete :destroy, params: {id: answer, question_id: answer.question_id}}.not_to change(Answer, :count)
      end

      it 'redirects to question' do
        delete :destroy, params: {id: answer, question_id: answer.question_id}
        expect(response).to redirect_to question_path(answer.question)
      end
    end
  end
end


