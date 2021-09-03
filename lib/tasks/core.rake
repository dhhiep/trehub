require 'active_record'

namespace :db do
  desc %q{Loads a specified fixture file:
use rake db:load_file[/absolute/path/to/sample/filename.rb]}

  task :load_file, [:file, :dir] => :environment do |_t, args|
    file = Pathname.new(args.file)

    puts "loading ruby #{file}"
    require file
  end

  desc 'Loads fixtures from the the dir you specify using rake db:load_dir[loadfrom]'
  task :load_dir, [:dir] => :environment do |_t, args|
    dir = args.dir
    dir = File.join(Rails.root, 'db', dir) if Pathname.new(dir).relative?

    ruby_files = {}
    Dir.glob(File.join(dir, '**/*.{rb}')).each do |fixture_file|
      ext = File.extname fixture_file
      ruby_files[File.basename(fixture_file, '.*')] = fixture_file
    end
    ruby_files.sort.each do |fixture, ruby_file|
      # If file exists within application it takes precendence.
      if File.exist?(File.join(Rails.root, 'db/default/spree', "#{fixture}.rb"))
        ruby_file = File.expand_path(File.join(Rails.root, 'db/default/spree', "#{fixture}.rb"))
      end
      # an invoke will only execute the task once
      Rake::Task['db:load_file'].execute(Rake::TaskArguments.new([:file], [ruby_file]))
    end
  end
end
