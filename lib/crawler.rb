require_relative "config/helpers"
require_relative "config/config"
require_relative "config/db"
path = File.expand_path("crawler/models", __dir__)
Helpers.require_dir(path)
include Crawler
include Crawler::Models

require_relative "crawler/bot"

Bot.start