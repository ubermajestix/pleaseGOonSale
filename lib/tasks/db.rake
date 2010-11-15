namespace :db do
  desc "how big is the database?"
  task :size => :environment do
    # This looks to be hardcoded by heroku...
    sql = "SELECT pg_size_pretty(pg_database_size('qmzxruylrc'));"
    puts ActiveRecord::Base.connection.execute(sql)[0]["pg_size_pretty"]
  end
  namespace :tables do
    desc "how big is each table?"
    task :size => :environment do
      sql = "SELECT tablename FROM pg_tables WHERE schemaname = 'public' ORDER BY tablename;"
      tables = ActiveRecord::Base.connection.execute(sql)
      sizes = []
      tables.each do |table|
        name = table['tablename']
        sql = "SELECT pg_size_pretty(pg_total_relation_size('#{name}'));"
        res = ActiveRecord::Base.connection.execute(sql)
        puts res[0].inspect
        puts "#{name} #{res[0]['pg_size_pretty']}"
        sizes << res[0]['pg_size_pretty'].gsub(/\D+/,'')
      end
      puts sizes.sum
    end
  end
end