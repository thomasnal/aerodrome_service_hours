class Notamn
  property :id
  getter :hours

  # Define day names directly. Date::DAY_ABBRV would need processing everytime
  DAYS = ["MON", "TUE", "WED", "THU", "FRI", "SAT", "SUN"]

  def initialize
    @id = nil
    @hours = {} of String => Array(String)
  end

  # Processing days split in Notamn as interface exposed by the class.
  # This is a logic that is not related to parsing.
  def add_hours(days_range = Range.new(Int, Int), hours = [] of String)
    from = DAYS.index(days_range.begin)
    to = DAYS.index(days_range.end)

    days = [] of String
    days = DAYS[from..to] if from.is_a?(Int) && to.is_a?(Int)
    days2 = days.map { |d| [d, hours] } if days.is_a?(Array(String))

    days.each do |d|
      @hours[d] = hours
    end
  end

  def hours_for_day(day : Symbol)
    return ["N/A"] unless @hours.keys.include? day
    @hours[day]
  end
end
