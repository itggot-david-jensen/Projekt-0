require_relative "inputhandler.rb"

class DBhandler

    def self.connect

        @db ||= SQLite3::Database.new('db/db.db')
        @db.results_as_hash = true
        @db

    end

    # Public: gets values from database
    # 
    # Examples
    # 
    # DBhandler.get do {:columns => "*", :nondefault_table => "Example"}
    #   #=> all items in table "Example"
    def self.get(&blk)

        connect

        input = yield

        # puts '------'
        # puts ''
        # puts input
        # puts ''
        # puts '------'

        if input[:fragment] == nil

            input[:fragment] = ""

        end

        if input[:nondefault_table]

            @db.execute("SELECT #{input[:columns]} FROM #{input[:nondefault_table]} #{input[:fragment]}", input[:condition]) 
            
        else

            @db.execute("SELECT #{input[:columns]} FROM #{@table_name} #{input[:fragment]}", input[:condition]) 
        
        end
    end

    # Public: inserts a series of values into a database
    # 
    # Examples
    # 
    # Class_inheriting_DBhandler.insert do {:insertion => {"bananpaj" => "god"}} end
    #   #=> "god" has been inserted into column "bananpaj" on table @table_name
    def self.insert(&blk)

        connect

        input = yield

        columns = Input.list_to_string(input[:insertion].keys)

        values = Input.list_to_string(input[:insertion])
        
        # puts '------'
        # puts ''
        # p columns
        # puts ''
        # puts '------'
        # puts ''
        # p values
        # puts ''
        # puts '------'

        if input[:nondefault_table] != nil

            @db.execute("INSERT INTO #{input[:nondefault_table]} (#{columns}) VALUES (#{values})")

        else

            @db.execute("INSERT INTO #{@table_name} (#{columns}) VALUES (#{values})")

        end
    
    end

end

class Student < DBhandler

    @table_name = "students"
    @column_names = ["id", "name", "img_path"]

    def self.add(&blk)

        input = yield

        insert do {:insertion => Input.array_to_hash(input[:student], @column_names)} end

    end

end