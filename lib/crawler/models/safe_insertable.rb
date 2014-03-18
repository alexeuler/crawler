require_relative "../logging"

module Crawler
  module Models
    module SafeInsertable

      include Logging

      attr_accessor :mutex

      def self.extended(base)
        base.mutex ||= Mutex.new
      end

      def unique_id(id)
        @unique_id_symbols = id.is_a?(Array) ? id : [id]
      end

      def insert(models)
        return [] if models.nil?
        models = models.is_a?(Array) ? models : [models]
        models.compact!
        return [] if models == []
        to_save = models.select { |model| model.id.nil? }
        return models if to_save.count == 0
        mutex.synchronize do
          in_db = fetch_existing_from_db(to_save)
          in_db_ids = in_db.map { |model| model_ids(model) }
          to_db = to_save.select { |model| not in_db_ids.include?(model_ids(model)) }
          insert_to_db(to_db)
          to_db_refetched = fetch_existing_from_db(to_db)
          models - to_save + in_db + to_db_refetched
        end
      end

      private
      def insert_to_db(models)
        log "Saving #{models.count} #{models[0].class.name.split("::").last}s"
        sql = "INSERT INTO #{self.table_name} "
        attr_names = models[0].attributes.keys
        attr_names.delete("id")
        sql += "(#{attr_names.join(",")}) "
        sql += "VALUES "
        values = models.map do |model|
          vals = []
          model.attributes.each_pair do |key, value|
            vals << value unless key == "id"
          end
          vals = vals.map { |val| val.nil? ? "NULL" : "'#{val}'" }
          "(#{vals.join(",")})"
        end
        sql += values.join(", ")
        ActiveRecord::Base.connection.execute sql
      end

      def fetch_existing_from_db(models)
        ids = models.map { |model| model_ids(model).join("_") }
        ids = ids.join("','")
        id_names = @unique_id_symbols.join(" || '_' || ")
        self.where("#{id_names} IN ('#{ids}')").to_a
      end

      def model_ids(model)
        @unique_id_symbols.map { |symbol| model.send(symbol) }
      end

    end

  end
end