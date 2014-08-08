class User < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true
  has_secure_password

  has_many :projects
  has_many :tasks
  has_many :shifts
end
