require 'celluloid'
require_relative "../config/db"
require_relative "vk_api"
require_relative "logging"

module Crawler
  class Spider
    include Celluloid
    include Logging

    MIN_LIKES = 5
    JOB_SIZE = 10000

    @@mutex = Mutex.new

    def initialize(args = {})
      @active = true
      @number = args[:number]
      async.start
    end

    def start
      connection = ActiveRecord::Base.connection
      @api = VkApi.new
      Thread.current[:number] = @number
      begin
        while @active
          user = get_job
          break if user.nil?
          posts = Post.fetch(user.vk_id)
          posts = posts.is_a?(Array) ? posts : [posts]
          posts = posts.select { |x| x.likes_count >= MIN_LIKES }
          posts_in_db = Post.insert(posts)
          posts_in_db.each do |post|
            post.fetch_likes
          end
          user.fetch_friends
          user.status = 1
          user.save
        end
      ensure
        ActiveRecord::Base.connection_pool.checkin(connection)
        @api.close
      end

    end

    private

    def get_job
      return nil if UserProfile.where(status: 1).count > JOB_SIZE
      user = nil
      @@mutex.synchronize do
        user = UserProfile.where(status: 0).first
        user.status = 2
        user.save
      end
      log "Spider: Fetched job"
      user
    end

  end
end