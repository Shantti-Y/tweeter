class User < ApplicationRecord
  has_many :tweets, dependent: :destroy
  has_many :active_relationships, class_name: "Relationship",
                                  foreign_key: "follower_id",
                                  dependent: :destroy
  has_many :following, through: :active_relationships, source: :following
  has_many :passive_relationships, class_name: "Relationship",
                                   foreign_key: "following_id",
                                   dependent: :destroy
  has_many :followers, through: :passive_relationships, source: :follower

  attr_accessor :remember_token, :activation_token, :reset_token

  before_save :improve_elements
  before_create :create_activation

  VALID_EMAIL_NUM_REGEX = /(\A[\w+\-.]+@[\w\d\-.]+\.[A-z]+\z|\A\d{10,11}\z)/
  IMPROVE_NAME_REGEX = /[\s]/

  validates :name, presence: true,
                   length: { maximum: 50 },
                   uniqueness: true
  validates :email_num, presence: true,
                        length: { maximum: 255 },
                        uniqueness: { case_sensitive: false },
                        format: { with: VALID_EMAIL_NUM_REGEX }
  validates :password, presence: true,
                       length: { minimum: 8 }

  has_secure_password

  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def User.new_token
    SecureRandom.urlsafe_base64
  end

  def remember
    self.remember_token = User.new_token
    self.update_attribute(:remember_digest, User.digest(self.remember_token))
  end

  def forget
    self.remember_token = nil
    self.update_attribute(:remember_digest, nil)
  end

  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end


  def create_reset_digest
    self.reset_token = User.new_token
    self.update_attribute(:reset_digest, User.digest(self.reset_token))
    self.update_attribute(:reseted_at, Time.zone.now)
  end

  def delete_reset_digest
    self.reset_token = nil
    self.update_attribute(:reset_digest, nil)
    self.update_attribute(:reseted_at, nil)
  end

  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  # Methods for creating and assuring relationships
  def follow(other_user)
    active_relationships.create(following_id: other_user.id)
  end

  def unfollow(other_user)
    active_relationships.find_by(following_id: other_user.id).destroy
  end

  def following?(other_user)
    following.include?(other_user)
  end

  def feed
    #following_ids = Relationship.where(follower_id: self.id)
    #Tweet.where(user_id: following_ids).or(Tweet.where(user_id: self.id))
    Tweet.where(user_id: self.following).or(Tweet.where(user_id: self.id))
  end

  def name_omit
    if self.name.size > 13
      self.name[0..12] + "..."
    else
      self.name
    end

  end

  private

    def improve_elements
      self.email_num = email_num.downcase
      self.name = name.sub(IMPROVE_NAME_REGEX, '_')
      self.name = name.downcase
    end

    def create_activation
      self.activation_token = User.new_token
      self.activation_digest = User.digest(self.activation_token)
    end
end
