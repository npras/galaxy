require_relative '../test_helper'
require_relative '../../lib/galaxy/parser'


describe Galaxy::Parser do

  before do
    @input = StringIO.new(<<~STR
    duck is I
    prok is V
    pish is X
    tegj is L
    duck duck Silver is 34 Credits
    duck prok Gold is 57800 Credits
    pish pish Iron is 3910 Credits
    how much is pish tegj duck duck ?
    how many Credits is duck prok Silver ?
    how many Credits is duck prok Gold ?
    how many Credits is duck prok Iron ?
    how much wood could a woodchuck chuck if a woodchuck could chuck wood ?
    STR
    )

    @obj = Galaxy::Parser.new(@input)
  end


  it "must parse successfully" do
    @obj.parse!

    _(@obj.data.tokens).must_equal ({"duck"=>"I", "prok"=>"V", "pish"=>"X", "tegj"=>"L"})
    
    result = [
      { commodity: "Silver", galactic_count: "duck duck", credit: 34 },
      { commodity: "Gold", galactic_count: "duck prok", credit: 57_800 },
      { commodity: "Iron", galactic_count: "pish pish", credit: 3910 },
    ]
    _(@obj.data.commodities).must_equal result

    result = {
      galactic_counts: [ "pish tegj duck duck" ],
      commodity_credits: [
        {:galactic_count=>"duck prok", :commodity=>"Silver"},
        {:galactic_count=>"duck prok", :commodity=>"Gold"},
        {:galactic_count=>"duck prok", :commodity=>"Iron"},
      ],
    }
    _(@obj.data.questions).must_equal result

    result = [
      "how much wood could a woodchuck chuck if a woodchuck could chuck wood ?",
    ]
    _(@obj.data.errors).must_equal result
  end


  it "#process_line" do
    obj = Galaxy::Parser.new('dummy')

    # tokens
    line = "kant is X"
    obj.process_line(line)
    result = { "kant" => "X" }
    _(obj.data.tokens).must_equal result

    # commodities
    line = "glob prok Gold is 57800 Credits"
    obj.process_line(line)
    result = [
      { galactic_count: "glob prok", commodity: "Gold", credit: 57_800 }
    ]
    _(obj.data.commodities).must_equal result

    line = "how much is pish tegj glob glob ?"
    obj.process_line(line)
    result = [
      "pish tegj glob glob"
    ]
    _(obj.data.questions[:galactic_counts]).must_equal result

    line = "how many Credits is glob prok Gold ?"
    obj.process_line(line)
    result = [
      { galactic_count: "glob prok", commodity: "Gold" }
    ]
    _(obj.data.questions[:commodity_credits]).must_equal result

    line = "how much wood could a woodchuck chuck if a woodchuck could chuck wood ?"
    obj.process_line(line)
    result = [
      "how much wood could a woodchuck chuck if a woodchuck could chuck wood ?"
    ]
    _(obj.data.errors).must_equal result

  end


end
