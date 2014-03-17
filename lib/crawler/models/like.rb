require_relative "fetchable"
require_relative "safe_insertable"

module Crawler
  module Models
    class Like < ActiveRecord::Base
      #Fetch method returns an array of Like models with user_profile_id
      # set to vk_id of UserProfile
      extend Fetchable
      fetcher :likes_getList, [:item_id, :owner_id], Mapping.like

      extend SafeInsertable
      unique_id [:post_id, :user_profile_id]

      validates_uniqueness_of :post_id, scope: :user_profile_id

      belongs_to :user_profile
      belongs_to :post

    end
  end
end
