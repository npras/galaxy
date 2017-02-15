module Galaxy

  class GalacticLiteralError < StandardError; end
  class RomanLiteralError < StandardError; end

  class Numeral

    ROMANS = {
      'I' => 1,
      'V' => 5,
      'X' => 10,
      'L' => 50,
      'C' => 100,
      'D' => 500,
      'M' => 1000,
    }

    VALID_PAIRS = {
      "IV" => 4,
      "IX" => 9,
      "XL" => 40,
      "XC" => 90,
      "CD" => 400,
      "CM" => 900,
    }

    # Not used, as we use the cached values above
    UNSUBTRACTABLES = %w(V L D)

    UNREPEATABLES = %w(V L D)
    REPEATABLES = %w(I X C M)

    attr_writer :maps
    attr_accessor :commodities


    def initialize(maps: {})
      @maps = maps
      @commodities = {}
    end

    
    # pish tegj glob glob => XLII
    def galactic_to_roman(galactic)
      fail GalacticLiteralError, "Token not present" if galactic.nil? || galactic.empty?
      tokens = galactic.split
      fail GalacticLiteralError, "Invalid token present!" unless (tokens.uniq - @maps.keys).empty?
      tokens
        .map { |token| @maps.fetch(token) }
        .join
    end


    # MMVI => 2006
    # MCMXLIV => 1944
    def roman_to_arabic(str)
      validate_roman!(str)
      return ROMANS.fetch(str) if str.size == 1

      i = 0
      value = 0
      lindex = str.size - 1

      loop do
        if i >= lindex
          value += ROMANS.fetch(str[i]) if (i == lindex) && !VALID_PAIRS[str[i-1..i]]
          break value
        end

        if (sub_value = VALID_PAIRS[str[i..i+1]])
          i += 1
          value += sub_value
        else
          value += ROMANS.fetch(str[i])
        end

        i += 1
      end # loop do
    end


    def validate_roman!(str)
      fail RomanLiteralError, "Roman Literal can't be nil or empty" if str.nil? || str.empty?
      fail RomanLiteralError, "Invalid Roman Literals" unless (str.chars.uniq - ROMANS.keys).empty?

      chunks = str
        .each_char
        .chunk(&:itself)
        .map { |token, chunk| [token, chunk.size] }

      invalid_repeats = chunks.any? do |token, count|
        (count > 1) && UNREPEATABLES.include?(token)
      end
      fail RomanLiteralError, "#{UNREPEATABLES} can't be repeated" if invalid_repeats

      invalid_counts = chunks.any? do |token, count|
        (count > 3) && REPEATABLES.include?(token)
      end
      fail RomanLiteralError, "#{REPEATABLES} can't be repeated beyond 3 times in succession" if invalid_counts
    end


    #glob glob Silver is 34 Credits   -> II $S -> 2 $S = 34 =>    $S = 17
    #glob prok Gold is 57800 Credits  -> IV $G -> 4 $G = 57800 => $G = 14450
    #pish pish Iron is 3910 Credits   -> XX $I -> 20 $I = 3910 => $I = 195.5
    def calculate_and_save_commodity(commodity:, galactic_count:, credit:)
      roman = galactic_to_roman(galactic_count)
      value = roman_to_arabic(roman)
      commodities[commodity] = (credit.to_f/value)
    end


    #how many Credits is glob prok Silver ? => 68
    #how many Credits is glob prok Gold ? => 57800 
    #how many Credits is glob prok Iron ? => 782
    def calculate_price(commodity:, galactic_count:)
      roman = galactic_to_roman(galactic_count)
      value = roman_to_arabic(roman)
      value * commodities.fetch(commodity)
    end


  end
end
