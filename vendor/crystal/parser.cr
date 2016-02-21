#
# Author: Tomas Nalevajko
# Date: 19.2.2016
#
# Crystal Ruby compiled to machine code.
#
# Unfortunately the compiled application is much much slower than
# Ruby interpreted :(
#

require "string_scanner"
require "./notamn"

class Parser
  getter :notamns

	DAYS = ["MON", "TUE", "WED", "THU", "FRI", "SAT", "SUN"]
  RE_EMPTY_LINE = /\n/

  def initialize(str)
    @buffer = StringScanner.new(str)
    @notamns = [] of Notamn
    @notamn = Notamn.new
    @count = 0
    parse
  end

  def parse
    @notamn = Notamn.new

    until @buffer.eos?
      parse_section
      skip_line

      if @buffer.scan(RE_EMPTY_LINE) || @buffer.eos?
        # store the Notamn if a valid E section was found
        @count += 1
        puts "...Notamns read " + @count.to_s if @count % 50 == 0
        @notamns << @notamn if @notamn.hours.keys.size > 0
        @notamn = Notamn.new
      end
    end
  end

  def parse_section
    case get_section
    when "A"
      parse_a
      # puts "Notamns found " + @count.to_s
    when "E"
      parse_e
      # if you want to parse new constructs add them here
    end
  end

  def get_section
    @buffer.scan /(?<section>\w)\)\s*/
    @buffer["section"] unless @buffer[0]?.nil?
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
      (?<from>#{DAYS.join("|")})
      -?
      (?<to>#{DAYS.join("|")})?
        \s*
        /x
    )
    unless days.nil?
      from, to = @buffer["from"]?, @buffer["to"]?

      hours_list = Array(String).new
      while (hours = parse_hours)
        hours_list << hours
      end

      if hours_list.size > 0
        to = from if to.nil?
        @notamn.add_hours days_range: from..to, hours: hours_list
      end
    end
  end

  def parse_hours
    if @buffer.scan /((?<hours>\d{4}-\d{4})|(?<closed>CLOSED))[,\s]*/
      return (@buffer["hours"]? ? @buffer["hours"] : @buffer["closed"])
    end
  end

  def skip_line
    @buffer.skip_until /\n/
  end
end

puts "Hello Crystal"
input = File.read("notamn.in")
p = Parser.new(input)
puts "Number of notamns: " + p.notamns.size.to_s
