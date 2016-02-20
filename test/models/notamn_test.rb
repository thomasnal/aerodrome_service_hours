require 'test_helper'

describe Notamn do
  it 'must return opening hours for day' do
    n = Notamn.new
    n.id = 'ESGJ'
    n.add_hours :days_range => 'MON'..'SUN', :hours => '0800-1000'
    assert_equal 'ESGJ', n.id
    Notamn::DAYS.each do |d|
      assert_equal ['0800-1000'], n.hours_for_day(d.downcase.to_sym),
        d.downcase.to_sym
    end

    n = Notamn.new
    n.add_hours :days_range => 'MON'..'MON', :hours => ['0800-1000', '1200-1500']
    assert_equal ['0800-1000', '1200-1500'], n.hours_for_day(:mon)
  end

  it 'must return n/a if hours for day are not set' do
    n = Notamn.new
    n.add_hours :days_range => 'MON'..'MON', :hours => ['0800-1000', '1200-1500']
    assert_equal ['N/A'], n.hours_for_day(:tue)

    n = Notamn.new
    n.add_hours :days_range => 'TUE'..'MON', :hours => '0800-1000'
    assert_equal ['N/A'], n.hours_for_day(:mon)
    assert_equal ['N/A'], n.hours_for_day(:tue)
  end
end
