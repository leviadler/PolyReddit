class User < ActiveRecord::Base
  attr_reader :password
  
  validates :email, presence: true, uniqueness: true
  validates :session_token, presence: true, uniqueness: true
  validates :password_digest, presence: { message: "Password cannot be blank" }
  validates :password, length: { minimum: 6, allow_nil: true }
  
  before_validation :ensure_session_token
  
  has_many :subs, class_name: "Sub", foreign_key: :moderator_id, primary_key: :id
  has_many :posts, class_name: "Post", foreign_key: :submitter_id, primary_key: :id
  
  def self.generate_session_token
    SecureRandom.urlsafe_base64(16)
  end
  
  def self.find_by_credentials(user_params)
    user = User.find_by(email: user_params[:email])
    return nil unless user
    return user if user.is_password?(user_params[:password])
  end
  
  def reset_session_token!
    self.session_token = User.generate_session_token
    self.save!
    self.session_token
  end
  
  def password=(password)
    if password.present?
      @password = password
      self.password_digest = BCrypt::Password.create(password)
    end
  end
  
  def is_password?(password)
    BCrypt::Password.new(self.password_digest).is_password?(password)
  end
  
  def ensure_session_token
    self.session_token ||= User.generate_session_token
  end
end
