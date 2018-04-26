require 'rails_helper'

RSpec.describe User, type: :model do
  it {should have_many(:questions).dependent(:destroy)}
  it {should have_many(:answers).dependent(:destroy)}

  it {should validate_presence_of :email}
  it {should validate_presence_of :password}

  describe 'author_of?' do
    let(:user) {create(:user)}
    let(:user2) {create(:user)}
    let(:question) {create(:question, user: user)}
    let(:answer) {create(:answer, user: user)}

    it 'should return true if user owns the question' do
      expect(user.author_of?(question)).to eq true
    end

    it 'should return false if user does not own the question' do
      expect(user2.author_of?(question)).to eq false
    end
  end

  describe 'for_oauth' do
    context 'user does not exist' do
      let(:auth) { OmniAuth::AuthHash.new(provider: 'twitter', uid: '123456', info: { email: 'new_test@user.ru' }) }

      it 'find_for_oauth should creates new user' do
        expect { User.find_for_oauth(auth) }.to change(User, :count).by(1)
      end

      it 'returns new user' do
        expect(User.find_for_oauth(auth)).to be_a(User)
      end

      it 'fills user email' do
        user = User.find_for_oauth(auth)
        expect(user.email).to eq auth.info[:email]
      end

      it 'should creates auth for user' do
        user = User.find_for_oauth(auth)
        expect(user.authorizations).to_not be_empty
      end

      it 'creates authorization with provider and uid' do
        authorization = User.find_for_oauth(auth).authorizations.first

        expect(authorization.provider).to eq auth.provider
        expect(authorization.uid).to eq auth.uid
      end
    end
  end

end
