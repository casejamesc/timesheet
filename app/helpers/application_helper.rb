module ApplicationHelper

  def body_class
    [controller_name, action_name].join('-')
  end
  
  def filter_class
    params[:filter]
  end

  # highlight appropriate nav_link
  def in_path?(*name)
    name.each do |n| 
      return 'active' if request.fullpath.include?(n)
    end
    ''
  end

  # can also use Date.today.advance(weeks: -1) here
  def beginning_of_this_week
    Date.today.beginning_of_week - 1.day
  end

  def end_of_this_week
    Date.today.end_of_week - 1.day
  end

  def beginning_of_last_week
    Date.today.advance(weeks: -1).beginning_of_week - 1.day
  end

  def end_of_last_week
    Date.today.advance(weeks: -1).end_of_week - 1.day
  end

  def beginning_of_last_month
    Date.today.advance(months: -1).beginning_of_month
  end

  def end_of_last_month
    Date.today.advance(months: -1).end_of_month
  end


  def default(value)
    if value 
      image_tag("icon-complete.png", class: "check")
    else
      '-'
    end
  end

  def status(value)
    if value 
      image_tag("icon-complete.png", class: "check")
    else
      '-'
    end
  end

  def project_link(shift) 
    shift.project ? ( link_to shift.project.name, edit_project_path(shift.project) ) : ''
  end

  def task_link(shift) 
    shift.task ? ( link_to shift.task.name, edit_task_path(shift.task) ) : ''
  end

  def project_default
    @current_user.projects.each do |project|
      return project if project.default
    end
    return Project.new
  end

  def task_default(project)
    project.tasks.each do |task|
      return task if task.default
    end
    return Task.new
  end
end
