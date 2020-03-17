module VihBot
  class RequestHandler
    private property logger : Logger

    def initialize(@logger = VihBot.logger); end

    def process_request(env)
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

    def self.process_request(env)
      new.process_message(env)
    end
  end
end
