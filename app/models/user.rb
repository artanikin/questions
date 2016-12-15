class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:facebook, :twitter, :vkontakte]

  has_many :questions, foreign_key: :author_id, dependent: :destroy
  has_many :answers, foreign_key: :author_id, dependent: :destroy
  has_many :authorizations, dependent: :destroy
  has_many :subscribes, foreign_key: :author_id,  dependent: :destroy

  scope :without, -> (id) { where("id != ?", id) }

  def author?(object)
    object.author_id == self.id
  end

  def self.find_for_oauth(auth)
    return if (auth.blank? || auth.provider.blank? || auth.uid.blank?)

    authorization = Authorization.where(provider: auth.provider, uid: auth.uid.to_s).first
    return authorization.user if authorization

    user = User.find_or_initialize_by(email: auth.info[:email])
    authorization = user.authorizations.build(provider: auth.provider, uid: auth.uid)

    if user.persisted?
      authorization.save
    else
      user.skip_confirmation!
      user.save! if user.email
    end

    user
  end

  def self.new_with_session(params, session)
    if session['devise.authorization']
      user = find_or_initialize_by(email: params[:email])
      user.authorizations.build(session['devise.authorization'])

      if user.persisted?
        user.update(confirmed_at: nil) && user.send_reconfirmation_instructions
      else
        user.attributes = params
        user.valid?
      end
      user
    else
      super
    end
  end

  def password_required?
    super && authorizations.blank?
  end

  def update_with_password(params, *options)
    if encrypted_password.blank?
      update_attributes(params, *options)
    else
      super
    end
  end

  def has_subscribe?(question)
    subscribes.where(question: question).exists?
  end

  def get_subscribe(question)
    subscribes.where(question: question).first
  end
end
