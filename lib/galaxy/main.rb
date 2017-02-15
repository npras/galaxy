module Galaxy
  class Main


    def process!(args)
      input = process_input(args)
      output = create_output(input)
      Galaxy.logger.info output
      puts output
    end


    private def process_input(args)
      parser = Parser.new(File.open(args.first))
      parser.parse!
      parser.data
    end


    private def create_output(input)
      output = ''
      @error_response = "I have no idea what you are talking about"

      numeral = Numeral.new(maps: input.tokens)

      input.commodities.each do |h|
        numeral.calculate_and_save_commodity(
          commodity: h[:commodity],
          galactic_count: h[:galactic_count],
          credit: h[:credit],
        )
      end

      #ip: how much is pish tegj glob glob ?
      #op: pish tegj glob glob is 42
      output << input.questions[:galactic_counts].map do |gc|
        error_replacement do
          roman = numeral.galactic_to_roman(gc)
          value = numeral.roman_to_arabic(roman)
          "#{gc} is #{value}"
        end
      end.join("\n")

      output << "\n"

      #ip: how many Credits is glob prok Silver ?
      #op: glob prok Silver is 68 Credits
      output << input.questions[:commodity_credits].map do |q|
        error_replacement do
          value = numeral.calculate_price(
            commodity: q[:commodity],
            galactic_count: q[:galactic_count]
          )
          "#{q[:galactic_count]} #{q[:commodity]} is #{value.to_i} Credits"
        end
      end.join("\n")

      output << "\n"

      output << ("#{@error_response}\n" * input.errors.size)

      output
    end


    private def error_replacement
      yield
    rescue
      @error_response
    end


  end
end
