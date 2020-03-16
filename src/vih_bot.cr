require "logger"

require "./vih_bot/server"

module VihBot
  VERSION = "0.1.0"

  TELEGRAM_API_HOST = "https://api.telegram.org/"
  TELEGRAM_BOT_TOKEN = ENV.fetch("TELEGRAM_BOT_TOKEN") do
    raise ArgumentError.new("TELEGRAM_BOT_TOKEN env var must be assigned.")
  end

  def self.logger
    @@logger ||= Logger.new(STDOUT)
  end
end

VihBot::Server.run
