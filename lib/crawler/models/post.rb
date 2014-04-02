require_relative "safe_insertable"
require_relative "fetchable"
require_relative "mapping"
require_relative "../logging"


module Crawler
  module Models
    class Post < ActiveRecord::Base
      include Crawler::Logging

      extend Fetchable
      fetcher :wall_get, :owner_id, Mapping.post

      extend SafeInsertable
      unique_id [:vk_id, :owner_id]

      def self.load_or_fetch(id)
        fetched = Post.fetch(id)
        in_db = Post.where(owner_id: id).to_a
        in_db_ids = in_db.map(&:vk_id)
        fetched.delete_if { |model| in_db_ids.include? model.vk_id}
        to_db = self.insert(fetched)
        in_db + to_db
      end

    end
  end
end