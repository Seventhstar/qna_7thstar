require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) {create(:question)}

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
end
