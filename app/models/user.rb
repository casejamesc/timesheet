class User < ActiveRecord::Base
  validates :first_name, :last_name, presence: true
  validates :username, :email, presence: true, uniqueness: true
  validates :email, email_format: { message: "doesn't look like an email address" }
  has_secure_password

  has_many :projects
  has_many :tasks
  has_many :shifts
end
