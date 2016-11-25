class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:facebook, :twitter]

  has_many :questions, foreign_key: :author_id, dependent: :destroy
  has_many :answers, foreign_key: :author_id, dependent: :destroy
  has_many :authorizations, dependent: :destroy

  def author?(object)
    object.author_id == self.id
  end

  def self.find_for_oauth(auth)
    authorization = Authorization.where(provider: auth.provider, uid: auth.uid.to_s).first
    return authorization.user if authorization

    email = auth.info[:email]
    if email
      user = User.where(email: email).first
      if user
        user.authorizations.create(provider: auth.provider, uid: auth.uid)
      else
        password = Devise.friendly_token[0, 20]
        user = User.create!(email: email, password: password, password_confirmation: password)
        user.authorizations.create(provider: auth.provider, uid: auth.uid)
      end
    else
      user = User.new
      user.authorizations.build(provider: auth.provider, uid: auth.uid)
    end
    user
  end

  def self.new_with_session(params, session)
    if session['devise.user_attributes']
      # new(session['devise.user_attributes'], without_protection: true) do |user|
      new(session['devise.user_attributes']) do |user|
        user.attributes = params
        user.authorizations.build(session['authorization'])
        user.valid?
      end
    else
      super
      user.authorizations.create(session['authorization'])
    end
  end

#   def password_required?
#     super
#   end
end
