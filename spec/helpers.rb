require 'socket'

module Helpers
  def socket_pair
    Socket.socketpair(:UNIX, :DGRAM, 0)
  end

  def self.require_dir(path)
    Dir["#{path}/*.rb"].each { |file| require file }
  end
end
