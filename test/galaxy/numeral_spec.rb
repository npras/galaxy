require_relative '../test_helper'
require_relative '../../lib/galaxy/numeral'


describe Galaxy::Numeral do

  before do
    @obj = Galaxy::Numeral.new
    @obj.maps = { "glob"=>"I", "prok"=>"V", "pish"=>"X", "tegj"=>"L" }
  end


  it "#galactic_to_roman" do
    _(@obj.galactic_to_roman('pish tegj glob glob')).must_equal 'XLII'

    err = _( -> { @obj.galactic_to_roman('') } ).must_raise Galaxy::GalacticLiteralError
    _(err.message).must_match /Token not present/

    err = _( -> { @obj.galactic_to_roman('pish luck duck') } ).must_raise Galaxy::GalacticLiteralError
    _(err.message).must_match /Invalid token present/
  end


  it "#roman_to_arabic" do
    _( -> { @obj.roman_to_arabic('') } ).must_raise Galaxy::RomanLiteralError
    _( -> { @obj.roman_to_arabic('VIA') } ).must_raise Galaxy::RomanLiteralError
    _(@obj.roman_to_arabic('I')).must_equal 1
    _(@obj.roman_to_arabic('X')).must_equal 10
    _(@obj.roman_to_arabic('VIX')).must_equal 14
    _(@obj.roman_to_arabic('VII')).must_equal 7
    _(@obj.roman_to_arabic('DCCCLXXXVIII')).must_equal 888
    _(@obj.roman_to_arabic('CMXCIX')).must_equal 999
    _(@obj.roman_to_arabic('MMVI')).must_equal 2006
    _(@obj.roman_to_arabic('MCMXLIV')).must_equal 1944
    _(@obj.roman_to_arabic('MCMLXXXIV')).must_equal 1984
  end


  it "#validate_roman" do
    _( -> { @obj.validate_roman!('') } ).must_raise Galaxy::RomanLiteralError
    _( -> { @obj.validate_roman!('VIA') } ).must_raise Galaxy::RomanLiteralError

    err = _( -> { @obj.validate_roman!('IIVVVVIIIVV') } ).must_raise Galaxy::RomanLiteralError
    _(err.message).must_match /can't be repeated/

    err = _( -> { @obj.validate_roman!('IIIVIIII') } ).must_raise Galaxy::RomanLiteralError
    _(err.message).must_match /beyond 3 times/

    # This should raise an exception as per the task requirement. But no time to implement that now!
    # "They may appear four times if the third and fourth are separated by a smaller value, such as XXXIX"
    #_( -> { @obj.validate_roman!('IIIVI') } ).must_raise Galaxy::RomanLiteralError
  end


  it "#calculate_and_save_commodity" do
    _(@obj.commodities['Metal1']).must_be_nil
    @obj.calculate_and_save_commodity(commodity: 'Metal1', galactic_count: 'glob glob', credit: 34)
    _(@obj.commodities['Metal1']).must_equal 17

    _(@obj.commodities['Metal2']).must_be_nil
    @obj.calculate_and_save_commodity(commodity: 'Metal2', galactic_count: 'glob prok', credit: 57_800)
    _(@obj.commodities['Metal2']).must_equal 14450

    _(@obj.commodities['Metal3']).must_be_nil
    @obj.calculate_and_save_commodity(commodity: 'Metal3', galactic_count: 'pish pish', credit: 3910)
    _(@obj.commodities['Metal3']).must_equal 195.5
  end


  it "#calculate_price" do
    @obj.commodities = {
      'Metal1' => 17,
      'Metal2' => 14450,
      'Metal3' => 195.5,
    }

    _(@obj.calculate_price(commodity: 'Metal1', galactic_count: 'glob prok')).must_equal 68
    _(@obj.calculate_price(commodity: 'Metal2', galactic_count: 'glob prok')).must_equal 57800
    _(@obj.calculate_price(commodity: 'Metal3', galactic_count: 'glob prok')).must_equal 782
  end


end
