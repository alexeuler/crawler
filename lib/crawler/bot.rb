require_relative "spider"

module Crawler
  class Bot
    SPIDERS_NUMBER = 5
    def self.start
      spiders = []
      SPIDERS_NUMBER.times do |i|
        spiders << Spider.supervise({number:i})
      end
      sleep
    end
  end
end
