require_relative 'galaxy/constants'

require 'byebug'
require 'logger'
require 'ostruct'

Process.setproctitle "galaxy"

module Galaxy
  extend self

  def logger
    FileUtils.mkdir_p('log')
    @logger ||= Logger.new(Galaxy::Constants::FILEPATH_LOG)
  end
end

require_relative 'galaxy/parser'
require_relative 'galaxy/numeral'
require_relative 'galaxy/main'
require_relative 'galaxy/cli'
