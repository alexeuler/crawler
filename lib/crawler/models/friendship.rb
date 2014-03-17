require_relative "fetchable"
require_relative "safe_insertable"

module Crawler
  module Models
    class Friendship < ActiveRecord::Base
      extend Fetchable
      fetcher :friends_get, :uid, Mapping.friendship

      extend SafeInsertable
      unique_id [:user_profile_id, :friend_id]

      belongs_to :user_profile
      belongs_to :friend, class_name: "UserProfile"

    end
  end
end
