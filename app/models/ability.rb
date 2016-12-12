class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user

    if user
      user.admin? ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end

  def guest_abilities
    can :read, :all
  end

  def admin_abilities
    can :manage, :all
  end

  def user_abilities
    guest_abilities
    can :create, [Question, Answer, Comment, Subscribe]
    can :update, [Question, Answer], author_id: user.id
    can :destroy, [Question, Answer, Subscribe], author_id: user.id
    can :destroy, Attachment, attachable: { author_id: user.id }

    can :best, Answer, question: { author_id: user.id }

    can [:vote_up, :vote_down], [Question, Answer] do |resource|
      resource.author_id != user.id
    end

    can [:read, :me], User
  end
end
