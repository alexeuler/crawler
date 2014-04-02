require_relative "safe_insertable"
require_relative "fetchable"
require_relative "mapping"
require_relative "../logging"


module Crawler
  module Models
    class UserProfile < ActiveRecord::Base
      include Crawler::Logging

      extend Fetchable
      fetcher :users_get, :uids, Mapping.user_profile
      MAX_PROFILES_PER_FETCH = 100

      extend SafeInsertable
      unique_id :vk_id

      def self.load_or_fetch(id)
        ids = id.is_a?(Array) ? id : [id]
        models = UserProfile.where(vk_id: ids).to_a
        existing = models.map(&:vk_id)
        new = ids - existing
        ((new.count-1) / MAX_PROFILES_PER_FETCH + 1).times do |i|
          ids_to_fetch = new[i*MAX_PROFILES_PER_FETCH..(i+1)*MAX_PROFILES_PER_FETCH - 1]
          fetched = UserProfile.fetch(ids_to_fetch)
          fetched = [fetched] unless fetched.is_a?(Array)
          models += fetched
        end
        models
      end

    end
  end
end
