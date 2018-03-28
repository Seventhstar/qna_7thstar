require 'rails_helper'

RSpec.describe OmniauthCallbacksController, type: :controller do
  let(:user) { create(:user) }

  describe 'github' do
    before do
      request.env["devise.mapping"] = Devise.mappings[:user]
      request.env["omniauth.auth"] = mock_auth_hash(:github)
    end

    context 'new user' do
      before { get :github }

      it "user doesn't log in" do
        expect(controller.current_user).to eq nil
      end

    end

    context 'returning user' do
      before do
        auth = mock_auth_hash(:github)
        create(:authorization, user: user, provider: auth.provider, uid: auth.uid)
        get :github
      end

      it 'user logs in user' do
        expect(controller.current_user).to eq user
      end

      it 'redirects to root_path' do
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe 'twitter' do
    before do
      request.env["devise.mapping"] = Devise.mappings[:user]
      request.env["omniauth.auth"] = mock_auth_hash(:twitter)
    end

    context 'new user' do
      before { get :twitter }

      it "user doesn't log in" do
        expect(controller.current_user).to eq nil
      end

      it 'redirects to add_email' do
        expect(response).to render_template 'omniauth_callbacks/add_email'
      end
    end

    context 'returning user' do
      before do
        auth = mock_auth_hash(:twitter)
        create(:authorization, user: user, provider: auth.provider, uid: auth.uid)
        get :twitter
      end

      it 'user logs in user' do
        expect(controller.current_user).to eq user
      end

      it 'redirects to login root_path' do
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe 'POST#register' do
    before do
      request.env["devise.mapping"] = Devise.mappings[:user]
    end

    it 'creates new user' do
      expect { post :register, params: { :auth_hash => { provider: "twitter", uid: "282040498", info: { email: "qwe@qweqwe.com" } } } }.to change(User, :count).by(1)
    end
  end
end