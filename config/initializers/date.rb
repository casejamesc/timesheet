class Date
  def beginning_of_last_week
    self.advance(week: -1).beginning_of_week
  end
  def end_of_last_week
    self.advance(week: -1).end_of_week
  end
end