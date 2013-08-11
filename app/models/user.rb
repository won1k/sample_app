# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  email           :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  password_digest :string(255)
#  remember_token  :string(255)
#  admin           :integer          default(0)
#  house           :string(255)
#  site            :string(255)
#  national_id     :integer
#  dorm            :string(255)
#  phone           :integer
#  course1         :string(255)
#  course2         :string(255)
#  course3         :string(255)
#  course4         :string(255)
#  rec1            :text
#  rec2            :text
#  grade1          :integer
#  grade2          :integer
#  grade3          :integer
#  grade4          :integer
#

class User < ActiveRecord::Base
  attr_accessible(:email, :name, :password, :password_confirmation, 
    :house, :site, :national_id, :course1, :course2, :course3, :course4, 
    :dorm, :phone, :grade1, :grade2, :grade3, :grade4, :rec1, :rec2, :rec1name, :rec2name)
  has_secure_password
  has_many :microposts, dependent: :destroy
  has_many :relationships, foreign_key: "follower_id", dependent: :destroy
  has_many :followed_users, through: :relationships, source: :followed
  has_many :reverse_relationships, foreign_key: "followed_id", 
      class_name: "Relationship", dependent: :destroy
  has_many :followers, through: :reverse_relationships

  before_save { email.downcase! }
  before_save :create_remember_token

  validates(:name, presence: true, length: { maximum: 50 })
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates(:email, presence: true, 
  	format: { with: VALID_EMAIL_REGEX }, 
  	uniqueness: { case_sensitive: false })
  validates(:password, presence: true, length: { minimum: 6 }, on: :create)
  validates(:password_confirmation, presence: true, on: :create)
  validates(:site, presence: true, on: :create)

  after_validation { self.errors.messages.delete(:password_digest) }

  SITES = ['Beijing','Shanghai']
  HOUSES = ['Aequitas','Amicitia','Animus','Dignitas','Fidus',
    'Inspiratio','Libertas','Lux','Pax','Spes','Virtus','Vis']
  DORMS = ['Sample Dorm 1','Sample Dorm 2','Sample Dorm 3','Sample Dorm 4']

  def feed
    followed_ids = "SELECT followed_id FROM relationships WHERE follower_id = :user_id"
    # @users = User.where(id: @followed_ids, site: self.site).each do |id| end
    user_ids = "SELECT id FROM users WHERE id IN (#{followed_ids}) AND site = :user_site"
    Micropost.where("user_id IN (#{user_ids}) OR user_id = :user_id", user_id: self.id, user_site: self.site)
  end

  def announcements
    # Feed of announcements from administrative users (staff)
    # @users = User.where(admin: 1, site: self.site)
    # Micropost.where(id: @users)
    user_ids = "SELECT id FROM users WHERE admin = 1 AND site = :user_site"
    Micropost.where("user_id IN (#{user_ids})", user_site: self.site)
  end

  def house_feed
    # Feed from house participants only
    # @users = User.where(house: self.house, site: self.site)
    # Micropost.where(id: @users)
    user_ids = "SELECT id FROM users WHERE house = :user_house AND site = :user_site"
    Micropost.where("user_id IN (#{user_ids})", user_house: self.house, user_site: self.site)
  end

  def self.search(search, user)
    search_condition = "%" + search + "%"
    find(:all, conditions: ['(name LIKE CAST(? AS TEXT) OR house LIKE CAST(? AS TEXT) OR email LIKE CAST(? AS TEXT) OR national_id LIKE CAST(? AS INT)) AND site LIKE CAST(? AS TEXT)', search_condition, search_condition, search_condition, search_condition, User.find(user).site])
  end

  def following?(other_user)
    relationships.find_by_followed_id(other_user.id)
  end

  def follow!(other_user)
    relationships.create!(followed_id: other_user.id)
  end

  def unfollow!(other_user)
    relationships.find_by_followed_id(other_user.id).destroy
  end

  private
    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end

end
