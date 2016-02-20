require 'test_helper.rb'

describe Parser do
	let(:notamn_in) {
		File.read(Rails.root.join('test', 'fixtures', 'input', 'notamn.in'))
	}
	let(:notamn2_in) {
		File.read(Rails.root.join('test', 'fixtures', 'input', 'notamn2.in'))
	}
	let(:notamn3_in) {
		File.read(Rails.root.join('test', 'fixtures', 'input', 'notamn2.in'))
	}
	let(:parser) { Parser.new(notamn2_in) }
	let(:parser_single) { Parser.new(notamn_in) }
	let(:parser_triple) { Parser.new(notamn3_in) }


	it 'must parse one notamn' do
		assert_equal 1, parser_single.notamns.length

		notamn = parser_single.notamns.first
		assert_equal 'ESGJ', notamn.id
		assert_equal '0500-1830', notamn.hours_for_day(:mon).first
		assert_equal '0630-0730', notamn.hours_for_day(:sat).first
		assert_equal '1900-2100', notamn.hours_for_day(:sat).second
		assert_equal 'CLOSED', notamn.hours_for_day(:sun).first
	end

	it 'must parse multiple notamns' do
		assert_equal 2, parser.notamns.length

		assert_equal 'ESGJ', parser.notamns.first.id
		assert_equal 'ESGJ2', parser.notamns.second.id
		assert_equal '0500-1830', parser.notamns.second.hours_for_day(:mon).first
	end

	it 'must parse notamns without E section' do
		assert_equal 2, parser_triple.notamns.length
	end
end
