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
      it 'deletes owned answer' do
        sign_in(answer.user)
        expect { delete :destroy, params: { id: answer, format: :js } }.to change(answer.user.answers, :count).by(-1)
      end

      it 'removing answer from view' do
        sign_in(answer.user)
        question = answer.question
        delete :destroy, params: {id: answer, format: :js}
        expect(response).to_not have_content answer.body
      end
    end

    context 'user tries to delete foreign answer' do
      sign_in_user
      it "doesn't delete foreign answer" do
        expect {delete :destroy, params: {id: answer, format: :js}}.not_to change(Answer, :count)
      end
    end
  end

  describe 'PATCH #set_best' do
    context 'owner of the question' do
      it 'sets best answer' do
        sign_in(answer.question.user)
        patch :set_best, params: { id: answer, format: :js }
        answer.reload
        expect(answer.best?).to be true
      end

      it 'changes best answer' do
        other_answer = create(:answer, question: answer.question, best: true)
        sign_in(answer.question.user)
        patch :set_best, params: { id: answer, format: :js }
        other_answer.reload
        expect(other_answer.best?).to be false
      end
    end

    it "doesn't set best answer to a question belonging to somebody else" do
      patch :set_best, params: { id: answer, format: :js }
      answer.reload
      expect(answer.best?).to be false
    end
  end
end


