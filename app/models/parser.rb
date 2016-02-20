#
# Author: Tomas Nalevajko
# Date: 19.2.2016
#
# The exercise samples indicate ambiguity while there is not enough data for
# its analysis as well as the problem description is not clear on them.
#
# For example, should closed days be stated as 'CLOSE' or 'CLOSED'.
# Should each line be expected to contain only one section?
# Should each section span only one line?
# Should FIR be handled differently comparing to ICAO in section A?
#
#
# Input format assumptions:
# - one line of input holds one and only one Notam section (id or section A-E)
# - empty line delimits Notam records
#
# Section A)
# - the content is treated as an identifier ICAO. It is composed of letters and
#   numbers. Meaning of FIR and how it should be handled is not explained.
# Section E)
# - multiple opening hours per day are delimited by ',', ' ' or ', '
#
#
# Per Alex' guidance, I can make the above assumptions to allow me to concentrate
# on test goals instead of spending time researching and resolving many
# different potential real world situations.
#

class Parser
  attr_reader :notamns

  RE_EMPTY_LINE = /^$/

  def initialize(str)
    @buffer = StringScanner.new(str)
    @notamns = []
    @notamn = nil
    parse
  end

  def parse
    @notamn = Notamn.new

    until @buffer.eos?
      parse_section
      skip_line

      if @buffer.scan RE_EMPTY_LINE || @buffer.eos?
        # store the Notamn if a valid E section was found
        @notamns << @notamn if @notamn.hours.keys.length > 0
        @notamn = Notamn.new
      end
    end
  end

  def parse_section
    case get_section
    when 'A'
      parse_a
    when 'E'
      parse_e
      # if you want to parse new constructs add them here
    end
  end

  def get_section
    @buffer.scan /(?<section>\w)\)\s*/
    @buffer[:section]
  end

  def parse_a
    @notamn.id = @buffer.scan /[\w\d]+/
  end

  def parse_e
    @buffer.scan /AERODROME HOURS OF OPS\/SERVICE\s*/
    while (days = parse_day)
      # keep parsing
    end
  end

  def parse_day
    days = @buffer.scan(
      /
      (?<from>#{Notamn::DAYS.join('|')})
      -?
      (?<to>#{Notamn::DAYS.join('|')})?
        \s*
        /x
    )
    if days.present?
      from, to = @buffer[:from], @buffer[:to]

      hours_list = []
      while (hours = parse_hours)
        hours_list << hours
      end

      if hours_list.length > 0
        to = from if to.blank?
        @notamn.add_hours :days_range => from..to, :hours => hours_list
      end
    end
  end

  def parse_hours
    if @buffer.scan /((?<hours>\d{4}-\d{4})|(?<closed>CLOSED))[,\s]*/
      return (@buffer[:hours].present? ? @buffer[:hours] : @buffer[:closed])
    end
  end

  def skip_line
    @buffer.skip_until /\n/
  end

  # XXX: perfrom benchmark objects vs. res
end
