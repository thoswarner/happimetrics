module DashboardHelper

  def other_day_path day, direction
    other_day = case direction
    when :previous
      day - 1.day
    when :next
      day + 1.day
    end
    day_path(other_day.day, other_day.month, other_day.year)
  end

  def other_week_path start_of_week_day, direction
    other_week = case direction
    when :previous
      start_of_week_day - 1.week
    when :next
      start_of_week_day + 1.week
    end
    week_path(other_week.day, other_week.month, other_week.year)
  end

end
