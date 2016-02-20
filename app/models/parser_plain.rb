#
# Implementation in this file is for performance reasons.
#

class ParserPlain
  attr_reader :notamns

  RE_EMPTY_LINE = /^\s*$/
  RE_SECTION_A = /A\) (?<id>[\w\d]+)/
  RE_SECTION_E = /E\) AERODROME HOURS OF OPS\/SERVICE (?<schedule>.*)\n/
  RE_DAYS = /
  (?<day>#{Notamn::DAYS.join('|')}) # match a day
  (-(?<day_to>#{Notamn::DAYS.join('|')}))? # or day range
  \s?	# optional space
  (?<hours>(\d{4}-\d{4}[,\s]*)+ # match service hours
  |
  CLOSED) # or closed
  /x 
  RE_HOURS = /\d{4}-\d{4}|CLOSED/

  def initialize(str)
    @notamns = []
    parse str
  end

  def parse txt
    re_sections = Regexp.new(
      RE_SECTION_A.to_s + '.*' + RE_SECTION_E.to_s,
      Regexp::MULTILINE)

    notamns = txt.split(RE_EMPTY_LINE)
    notamns.map! { |n| n.scan(re_sections) }
    notamns.map! { |txt| [txt[0][0], txt[0][1].scan(RE_DAYS)] unless txt.empty? }

    schedule = notamns.map do |n|
      [n[0], n[1].map { |d| [d[0], d[1], d[2].scan(RE_HOURS)] }] if n.present?
    end

    schedule.each do |n|
      next if n.nil?

      notamn = Notamn.new
      notamn.id = n[0]
      n[1].each do |d|
        from, to = d[0], d[1]

        to = from if to.nil?
        notamn.add_hours :days_range => from..to, :hours => d[2]
      end
      @notamns << notamn
    end
  end
end
