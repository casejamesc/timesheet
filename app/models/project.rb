class Project < ActiveRecord::Base
  belongs_to :user
  has_many :shifts
  has_many :tasks, dependent: :destroy

  before_save :update_defaults

  def update_defaults
    # only one project of a user can be the default
    if default
      Project.where('id <> ?', id).update_all({default: false}, {user_id: user_id})
    end
  end

end
