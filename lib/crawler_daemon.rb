require 'daemons'

dir = File.expand_path("../", File.dirname(__FILE__))

Daemons.run_proc('bot_daemon', {
    dir_mode: :normal,
    dir: "#{dir}/log",
    backtrabce: true,
    monitor: true,
    log_output: true
}) do
  require_relative "crawler"
end