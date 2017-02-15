require 'ostruct'

module Galaxy
  class Parser

    # tegj is L
    REGEX_CODE_DEFINITION = /(?<code>^[a-z]+) is (?<roman>[IVXLCDM])$/

    # glob glob Silver is 34 Credits
    REGEX_COMMODITY_EQUATION = /^(?<commodity_code_count>.*) (?<commodity>[A-Z]\w+) is (?<credits>\d+) Credits$/

    # how much is pish tegj glob glob ?
    REGEX_VALUE_QUESTION = /how much is (?<quantity>.*)\s\?$/

    # how many Credits is glob prok Silver ?
    REGEX_CREDIT_QUESTION = /how many Credits is (?<commodity_code_count>.*?) (?<commodity>[A-Z]\w+) \?$/


    attr_accessor :data


    def initialize(file)
      @file = file

      @data = OpenStruct.new
      data.tokens = {}
      data.commodities = []
      data.questions = { galactic_counts: [], commodity_credits: [] }
      data.errors = []
    end


    def parse!
      @file.each_line { |line| process_line(line.chomp!) }
    end


    def process_line(line)
      case line

      when REGEX_CODE_DEFINITION
        data.tokens[$~[:code]] = $~[:roman]

      when REGEX_COMMODITY_EQUATION
        data.commodities << { galactic_count: $~[:commodity_code_count], commodity: $~[:commodity], credit: $~[:credits].to_i }

      when REGEX_VALUE_QUESTION
        data.questions[:galactic_counts] << $~[:quantity]

      when REGEX_CREDIT_QUESTION
        data.questions[:commodity_credits] << { galactic_count: $~[:commodity_code_count], commodity: $~[:commodity] }

      else
        data.errors << line

      end
    end

  end
end
