class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :votes, dependent: :destroy
  has_many :authorizations, dependent: :destroy

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable,
         :omniauthable, omniauth_providers: [:twitter, :github]

  def author_of?(obj)
    self.id == obj.user_id
  end

  def self.find_for_oauth(auth)
    authorization = Authorization.where(provider: auth.provider, uid: auth.uid.to_s).first
    return authorization.user if authorization

    email = auth.info.try(:[], :email)
    user = User.where(email: email).first

    if user
      user.create_authorization(auth)
    elsif email

      password = Devise.friendly_token[0, 20]
      user = User.create!(email: email, password: password, password_confirmation: password)

      user.create_authorization(auth)
    else
      password = Devise.friendly_token[0, 20]
      user = User.create(password: password, password_confirmation: password)
    end

    user
  end

  def confirmation(token)
    
  end

  def create_authorization(auth)
    # p "create_authorization"
    self.authorizations.create(provider: auth.provider, uid: auth.uid)
  end

  def self.from_omniauth(auth)
    # p "from_omniauth"
    where(auth.slice("provider", "uid")).first || create_from_omniauth(auth)
  end

  
end
