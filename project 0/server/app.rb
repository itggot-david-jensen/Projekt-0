class Main < Sinatra::Base

    before do

        @db ||= SQLite3::Database.new('db/db.db')
        @db.results_as_hash = true
        @db

        puts '#====@db====#'
        p @db
        puts '#===/@db/===#'

    end

    get '/' do

        @students = @db.execute("SELECT * FROM students")

        puts '#====@students====#'
        p @students
        puts '#===/@students/===#'

        slim :index

    end

end