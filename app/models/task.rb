class Task < ActiveRecord::Base
  belongs_to :user
  belongs_to :project
  has_many :shifts

  before_save :update_defaults

  def update_defaults
    # only one task of a project can be the default
    if default
      Task.where('id <> ?', id).update_all({default: false}, {user_id: user_id, project_id: project_id})
    end
  end

end
