require "kemal"
require "json"

module VihBot
  class Server
    def logger
      VihBot.logger
    end

    def setup
      before_all "/:token" do |env|
        unless authorized?(env.params.url["token"])
          halt env, status_code: 401, response: "Unauthorized"
        end
      end

      post "/:token" do |env|
        logger.info("Params: #{env.params.json.to_s}")

        payload = env.params.json

        message   = payload["message"]?
        text      = message.is_a?(Hash(String, JSON::Any)) ? message["text"]? : nil
        from      = message.is_a?(Hash(String, JSON::Any)) ? message["from"]? : nil
        username  = from.is_a?(JSON::Any) ? from["username"]? : nil
        chat      = message.is_a?(Hash(String, JSON::Any)) ? message["chat"]? : nil
        chat_id   = chat.is_a?(JSON::Any) ? chat["id"]? : nil

        if text && username
          logger.info("I got a message from #{username}. Message: #{text}.")
        end

        if chat_id && text == "Hello Vih"
          logger.info("Sending greetings! :D")

          env.response.headers.add("Content-Type", "application/json")

          {
            method: "sendMessage",
            chat_id: chat_id,
            text: "Hi there! ;)"
          }.to_json
        else
          "OK"
        end
      end
    end

    def authorized?(token : String)
      token === TELEGRAM_BOT_TOKEN
    end

    def run
      setup
      Kemal.run
    end

    def self.run
      new.run
    end
  end
end
