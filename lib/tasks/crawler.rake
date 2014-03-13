dir=File.expand_path("../", File.dirname(__FILE__))

namespace :crawler do

  desc "runs crawler daemon"
  task :start do
    system "ruby #{dir}/crawler_daemon.rb start"
  end

  desc "kills crawler daemon"
  task :stop do
    system "ruby #{dir}/crawler_daemon.rb stop"
  end

  desc "restarts crawler daemon"
  task :restart do
    system "ruby #{dir}/crawler_daemon.rb restart"
  end

end