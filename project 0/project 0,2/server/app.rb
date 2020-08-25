require_relative "modules/dbhandler.rb"

class Main < Sinatra::Base

    enable :sessions

    before do

    end

    get '/' do

        # @students = @db.execute("SELECT * FROM students")

        @students = Student.get do {:columns => "*"} end

        slim :index

    end

    post '/add_student' do

        #do stuff

        Student.add do {:student => [params['name'], params['path']]} end

        redirect '/'

    end

end