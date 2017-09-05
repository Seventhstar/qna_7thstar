require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:question) {create(:question)}

  describe 'GET #index' do
    let(:questions) {create_list(:question, 2)}
    before {get :index}

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do

    before {get :show, params: {id: question}}

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    sign_in_user
    before {get :new}

    it 'assign a new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do
    sign_in_user
    before {get :edit, params: {id: question}}
    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'renders edit view' do
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    sign_in_user

    context 'with valid attributes' do
      it 'saves new question in DB' do
        expect {post :create, params: {question: attributes_for(:question)}}.to change(@user.questions, :count).to(1)
      end

      it 'redirect to show view' do
        post :create, params: {question: attributes_for(:question)}
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end

    context 'with invalid attributes' do
      it 'does not save question in DB' do
        expect {post :create, params: {question: attributes_for(:invalid_question)}}.to_not change(Question, :count)
      end

      it 're-render new view' do
        post :create, params: {question: attributes_for(:invalid_question)}
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    context 'valid attributes' do
      it 'assigns the requested question to @question' do
        sign_in(question.user)
        patch :update, params: {id: question, question: attributes_for(:question)}
        expect(assigns(:question)).to eq question
      end

      it 'changes question attributes' do
        sign_in(question.user)
        patch :update, params: {id: question, question: {title: 'new title', body: 'new body'}}
        question.reload #чтобы не кешировалось
        expect(question.title).to eq 'new title'
        expect(question.body).to eq 'new body'
      end

      it 'redirects to the updated question' do
        sign_in(question.user)
        patch :update, params: {id: question, question: attributes_for(:question)}
        expect(response).to redirect_to question
      end
    end

    context 'invalid attributes' do
      sign_in_user
      before {patch :update, params: {id: question, question: {title: 'new title', body: ''}}}
      it 'does not change question attributes' do
        question.reload
        expect(question.title).not_to eq 'new title'
      end

      it 're-renders edit view' do
        expect(response).to render_template :edit
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:question) {create(:question)}

    context 'auth.user deletes his question' do
      it 'deletes question' do
        sign_in(question.user)
        expect {delete :destroy, params: {id: question}}.to change(question.user.questions, :count).by(-1)
      end

      it 'redirect to index' do
        sign_in(question.user)
        delete :destroy, params: {id: question}
        expect(response).to redirect_to questions_path
      end
    end

    context 'auth.user tries to delete foreign question' do
      sign_in_user
      it 'tries to delete question' do
        expect {delete :destroy, params: {id: question}}.to_not change(Question, :count)  
      end

      it 're-renders edit view' do
        delete :destroy, params: {id: question}
        expect(response).to redirect_to questions_path
      end

    end

  end

end
