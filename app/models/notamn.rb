class Notamn
  attr_accessor :id
  attr_reader :hours

  # Define day names directly. Date::DAY_ABBRV would need processing everytime
  DAYS = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN']

  def initialize
    @id = nil
    @hours = {}
  end

  # Processing days split in Notamn as interface exposed by the class.
  # This is a logic that is not related to parsing.
  def add_hours days_range:, hours:
    hours = [hours] unless hours.is_a? Array

    days = DAYS[DAYS.index(days_range.first)..DAYS.index(days_range.last)]
    days.map! { |d| [d.downcase.to_sym, hours] }

    @hours.merge! days.to_h
  end

  def hours_for_day day
    return ['N/A'] unless @hours.keys.include? day
    @hours[day]
  end
end
