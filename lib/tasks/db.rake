db_namespace=namespace :db do

  task :environment do
    ActiveRecord::Migrator.migrations_paths=
        File.expand_path("../crawler/models/migrations", File.dirname(__FILE__))
  end

  desc "create database"
  task :create => :environment do
    ActiveRecord::Tasks::DatabaseTasks.create_current
  end

  desc "drop database"
  task :drop => :environment do
    ActiveRecord::Tasks::DatabaseTasks.create_current
  end

  desc "reset database"
  task :reset => ['db:drop', 'db:create', 'db:migrate']

  desc "runs pending migrations"
  task :migrate => :environment do
    ActiveRecord::Migrator.migrate(ActiveRecord::Migrator.migrations_paths)
    db_namespace['dump'].invoke
  end

  desc "rolls back the last migraion"
  task :rollback => :environment do
    ActiveRecord::Migrator.rollback(ActiveRecord::Migrator.migrations_paths, 1)
    db_namespace['dump'].invoke
  end

  task :dump => :environment do
    require 'active_record/schema_dumper'
    filename = File.join(ActiveRecord::Migrator.migrations_paths, 'schema.rb')
    File.open(filename, "w:utf-8") do |file|
      ActiveRecord::SchemaDumper.dump(ActiveRecord::Base.connection, file)
    end
    db_namespace['dump'].reenable
  end

  desc "creates the migration specified by arg"
  task :migration, [:name] => [:environment] do |task, args|
    file_name = "#{ActiveRecord::Migrator.migrations_paths[0]}/#{Time.now.strftime("%Y%m%d%H%M%S")}_#{args.name}.rb"
    file=File.new(file_name, "w")
    file.puts("class #{args.name.split('_').each { |s| s.capitalize! }.join('')} < ActiveRecord::Migration")
    file.puts("  def change")
    file.puts
    file.puts("  end")
    file.puts("end")
    file.close
  end
end
