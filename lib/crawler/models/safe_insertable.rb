module Crawler
  module Models
    module SafeInsertable

      attr_accessor :mutex

      def self.extended(base)
        base.mutex ||= Mutex.new
      end

      def unique_id(id)
        @unique_id_symbol = id
      end

      def insert(models)
        models = models.is_a?(Array) ? models : [models]
        mutex.synchronize do
          to_save = models.select { |model| model.id.nil? }
          unique_ids = to_save.map(&@unique_id_symbol)
          in_db_ids = self.where(@unique_id_symbol => unique_ids).
              select(@unique_id_symbol).to_a
          to_db = to_save.select do |model|
            not in_db_ids.include?(model.send(@unique_id_symbol))
          end
          insert_to_db(to_db)
        end
      end

      private
      def insert_to_db(models)
        ActiveRecord::Base.transaction do
          models.each do |u|
            u.save
          end
        end
      end
    end

  end
end