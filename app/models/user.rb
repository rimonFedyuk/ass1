class User < ActiveRecord::Base

  ATTRS = %w(first_name last_name email password password_digest current_session_token)

  has_secure_password

  validates :first_name, length: { minimum: AppConfig.user['min_length'] }
  validates :last_name, length: { minimum: AppConfig.user['min_length'] }
  validates :email, format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }
  validate  :password_requirements_are_met

  before_save :encrypt_password


  def password_requirements_are_met
    if password.present?
      rules = {
          "minimum eight in length"                     => /.{8,}/,
          "must contain at least one lowercase letter"  => /[a-z]+/,
          "must contain at least one uppercase letter"  => /[A-Z]+/,
          "must contain at least one digit"             => /\d+/,
          "must contain at least one special character" => /[^A-Za-z0-9]+/
      }

      rules.each do |message, regex|
        errors.add( :password, message ) unless password.match( regex )
      end
    end
  end

  def encrypt_password
    if password.present?
      self.password_digest = password_hash(password)
    end
  end

  def password_hash(password)
    Base64.encode64(Digest::SHA1.hexdigest(password))
  end
end
