class Report
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  attr_accessor :date1, :date2, :project_filter, :task_filter, :project_id, :task_id, :email

  validates_presence_of :date1, :date2
  validates :email, email_format: { message: "doesn't look like an email address" }

  DEFAULTS = [ :this_week, :last_week, :last_two_weeks, :this_month, :last_month]

  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end

  def persisted?
    false
  end
end