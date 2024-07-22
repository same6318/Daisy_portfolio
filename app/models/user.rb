class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, 
         :omniauthable, omniauth_providers: [:google_oauth2]
  has_many :topics
  has_many :reviews
  belongs_to :company, optional: true

  enum age: { teens: 0, twenties: 1, thirties: 2, forties: 3 }
  enum gender: { male: 0, female: 1, other: 2 }
  enum purpose: { personal: 0, business: 1, education: 2, hobby: 3 }
  enum role: { general: 0, company: 1, admin: 2 }
  validates :password, confirmation: true, length: { minimum: 6 }

  #Googleログイン
  def self.create_unique_string
    SecureRandom.uuid
  end

  def self.find_for_google(auth)
    user = User.find_by(email: auth.info.email)
  
    unless user
      user = User.new(email: auth.info.email,
                      provider: auth.provider,
                      uid:      auth.uid,
                      password: Devise.friendly_token[0, 20])
    end
    user.save
    user
  end
end
