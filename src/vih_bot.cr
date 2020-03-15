require "logger"
require "kemal"

module VihBot
  VERSION = "0.1.0"

  TELEGRAM_API_HOST = "https://api.telegram.org/"
  TELEGRAM_BOT_TOKEN = ENV.fetch("TELEGRAM_BOT_TOKEN") do
    raise ArgumentError.new("TELEGRAM_BOT_TOKEN env var must be assigned.")
  end

  class Server
    def logger
      @logger ||= Logger.new(STDOUT)
    end

    def set_filters
      before_all "/:token" do |env|
        unless authorized?(env.params.url["token"])
          halt env, status_code: 401, response: "Unauthorized"
        end
      end
    end

    def set_routes
      post "/:token" do |env|
        logger.info("Params got: #{env.params.json.to_s}")

        message = env.params.json["message"]

        body = message.is_a?(Hash(String, JSON::Any)) ? message["text"] : ""
        from = message.is_a?(Hash(String, JSON::Any)) ? message["from"] : { String => String }

        username = from["username"]

        logger.info("I got a message from #{username}. Message: #{body}.")

        "ok"
      end
    end

    def authorized?(token : String)
      token === TELEGRAM_BOT_TOKEN
    end

    def run
      set_filters
      set_routes
      Kemal.run
    end

    def self.run
      new.run
    end
  end

  def self.run
    Server.run
  end
end

VihBot.run
