module Crawler
  module Models
    module SafeInsertable

      attr_accessor :mutex

      def self.extended(base)
        base.mutex ||= Mutex.new
      end

      def unique_id(id)
        @unique_id_symbols = id.is_a?(Array) ? id : [id]
      end

      def insert(models)
        models = models.is_a?(Array) ? models : [models]
        mutex.synchronize do
          to_save = models.select { |model| model.id.nil? }
          assoc = self
          @unique_id_symbols.each do |unique_id_symbol|
            unique_ids = to_save.map(&unique_id_symbol)
            assoc = assoc.where(unique_id_symbol => unique_ids)
          end
          in_db_models = assoc.select(@unique_id_symbols).to_a
          in_db_ids = in_db_models.map { |model| model_ids(model)}
          to_db = to_save.select { |model| not in_db_ids.include?(model_ids(model)) }
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

      def model_ids(model)
        @unique_id_symbols.map { |symbol| model.send(symbol)}
      end

    end

  end
end