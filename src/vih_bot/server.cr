require "kemal"
require "json"

module VihBot
  class Server
    private getter handler : VihBot::RequestHandler
    private getter logger : Logger

    def initialize(@handler = VihBot::RequestHandler.new, @logger = VihBot.logger); end

    private def setup
      before_all "/:token" do |env|
        unless authorized?(env.params.url["token"])
          logger.warn("Unauthorized request!")
          halt(env, status_code: 401, response: "Unauthorized")
        end
      end

      post "/:token" do |env|
        logger.debug("Params: #{env.params.json.to_s}")
        handler.process_request(env)
      end
    end

    private def authorized?(token : String)
      token === TELEGRAM_BOT_TOKEN
    end

    def listen
      setup
      Kemal.run
    end

    def self.listen
      new.listen
    end
  end
end
