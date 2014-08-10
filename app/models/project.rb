class Project < ActiveRecord::Base
  belongs_to :user
  has_many :shifts
  has_many :tasks, dependent: :destroy
end
