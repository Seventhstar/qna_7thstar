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
    can :create, [Question, Answer, Comment]
    can [:update, :destroy], [Question, Answer, Comment], user_id: user.id
    
    can :set_best, Answer do |answer|
      user.author_of?(answer.question)
    end

    can :destroy, Attachment do |attachment|
      user.author_of?(attachment.attachable)
    end

    can :destroy, Comment do |comment|
      user.author_of?(comment.commentable)
    end

    can :create, Vote do |vote|
      !user.author_of?(vote.votable)
    end

    can :reset, Vote, user_id: user.id
    can :manage, User
  end
end
