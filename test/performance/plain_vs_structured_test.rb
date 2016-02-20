require 'test_helper'
require 'rails/performance_test_help'

class PlainVsStructuredTest < ActionDispatch::PerformanceTest
  self.profile_options = { runs: 1, metrics: [:wall_time],
                           output: 'tmp/performance', formats: [:flat] }
  def setup
    @input = ''
    f = File.open(Rails.root.join('test', 'fixtures', 'input', 'notamn3.in'))

    0.upto(10000) { @input << f.read << "\n"; f.rewind }
  end

  test "structured" do
    Parser.new(@input)
  end

  test "plain" do
    ParserPlain.new(@input)
  end
end
