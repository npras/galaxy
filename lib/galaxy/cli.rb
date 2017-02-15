require 'thor'

module Galaxy
  class CLI < Thor

    desc "process", "do the work!"
    def decipher(*args)
      Main.new.process!(args)
    end

  end
end
