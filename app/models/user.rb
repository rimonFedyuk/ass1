class User < ActiveRecord::Base
  ATTRS = %w(first_name last_name)

  validates :first_name, length: { minimum: AppConfig.user['min_length'] }
  validates :last_name, length: { minimum: AppConfig.user['min_length'] }
end
