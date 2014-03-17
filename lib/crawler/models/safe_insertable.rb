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
        sql = "INSERT INTO #{self.table_name} "
        attr_names = models[0].attributes.keys
        sql += "('#{attr_names.join("','")}') "
        sql += "VALUES "
        values = models.map do |model|
          vals = model.attributes.values.map {|val| val.nil? ? "NULL" : val}
          "(#{vals.join(",")})"
        end
        sql += values.join(", ")
        ActiveRecord::Base.connection.execute sql
        #ActiveRecord::Base.transaction do
        #  models.each do |u|
        #    u.save
        #  end
        #end
      end

      def fetch_existing_from_db(models)
        ids = models.map { |model| model_ids(model).join("_")}
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