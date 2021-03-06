require "colorize"
require "ecr"
require "file_utils"

class LuckyMigrator::MigrationGenerator
  getter :name
  @_version : String?

  ECR.def_to_s "#{__DIR__}/migration.ecr"

  def initialize(@name : String)
  end

  def generate
    make_migrations_folder_if_missing
    File.write(filename, contents)
  end

  private def make_migrations_folder_if_missing
    FileUtils.mkdir_p Dir.current + "/db/migrations"
  end

  private def filename
    Dir.current + "/db/migrations/#{version}_#{name.underscore}.cr"
  end

  private def version
    @_version ||= Time.now.to_s("%Y%m%d%H%M%S")
  end

  private def contents
    to_s
  end
end

class Gen::Migration < LuckyCli::Task
  banner "Generate a new migration"

  def call
    if ARGV.first? == nil
      puts "Migration name is required. Example: lucky gen.migration CreateUsers".colorize(:red)
    else
      LuckyMigrator::MigrationGenerator.new(name: ARGV.first).generate
      puts "Created migration"
    end
  end
end
