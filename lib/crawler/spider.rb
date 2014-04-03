require 'celluloid'
require_relative "../config/db"
require_relative "vk_api"
require_relative "logging"

module Crawler
  class Spider
    include Celluloid
    include Logging

    MIN_LIKES = 100
    JOB_SIZE = 100000
    MAX_PROFILES_PER_FETCH = 100

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
          next if user.nil?
          posts = Post.fetch(user.vk_id)
          posts = posts.is_a?(Array) ? posts : [posts]
          posts = posts.select { |x| x.likes_count >= MIN_LIKES }
          posts.each do |post|
            user_ids = Like.fetch([post.vk_id, post.owner_id]).map(&:user_profile_id)
            users = UserProfile.fetch(user_ids)
            birthdays = users.map(&:birthday)
            birthdays.compact!
            birthdays.map! {|b| b.to_time.to_f}
            if birthdays.count > 0
              sum = birthdays.inject(0.0) {|sum, x| sum+=x}
              post.likes_age =Time.at(sum / birthdays.count).year
            end
            friends_count = Friendship.fetch(user.vk_id).count
            post.likes_share = post.likes_count.to_f / friends_count unless post.likes_count.nil? or friends_count == 0

          end
          Post.insert(posts)
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
      if UserProfile.where(status: 1).count > JOB_SIZE
        @active = false
        return nil
      end
      user = nil
      @@mutex.synchronize do
        user = UserProfile.where(status: 0).first
        if user.nil?
          user = UserProfile.where(status: 1).first
          if user.nil?
            user = UserProfile.fetch(252752)
          end
          user.status = 2
          user.save
          friendships = Friendship.fetch(user.vk_id)
          ids = friendships.map(&:user_profile_id)
          models = UserProfile.load_or_fetch(ids)
          UserProfile.insert(models)
          return nil
        end
        user.status = 3
        user.save
      end
      log "Spider: Fetched job"
      user
    end

  end
end