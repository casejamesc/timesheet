class Shift < ActiveRecord::Base
  belongs_to :user
  belongs_to :project
  belongs_to :task

  validates :clock_in, :clock_out, :date_in, :date_out, presence: true

  scope :by_date_range, -> (date1, date2) { where("date_in >= ? AND date_out <= ?", date1, date2 ).order("clock_in ASC") }
  scope :by_day, -> (date) { where("date_in = ?", date ) }
  scope :by_project, -> (project) { where("project_id = ?", project.id ) }
  scope :by_task, -> (task) { where("task_id = ?", task.id ) }

  def duration
    self.clock_out - self.clock_in
  end

  def time
    minutes = (self.duration / 60) % 60
    hours = self.duration / (60 * 60)
    format("%02d:%02d", hours, minutes)
  end

  def pay
    if self.task && self.task.rate
      self.duration * self.task.rate / 3600
    elsif self.project && self.project.rate
      self.duration * self.project.rate / 3600
    else
      '0.00'
    end
  end

  def project_name
    self.project ? self.project.name : ''
  end

  def task_name
    self.task ? self.task.name : ''
  end
end
