module ApplicationHelper

  def body_class
    [controller_name, action_name].join('-')
  end
  
  # can also use Date.today.advance(weeks: -1) here
  def beginning_of_last_week
    1.week.ago.beginning_of_week
  end

  def end_of_last_week
    1.week.ago.end_of_week
  end

  def beginning_of_last_month
    1.month.ago.beginning_of_month
  end

  def end_of_last_month
    1.month.ago.end_of_month
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
end
