require 'bundler'
Bundler.require

require File.expand_path('../data', __FILE__)

class Creator
    def initialize
        @db_path = 'db/events.sqlite'
    end

    def create
        delete_db
        create_db
        create_table
        insert_rows
    end

    def delete_db
        if File.exists?(@db_path)
            puts "Removing #{ @db_path }"
            File.unlink @db_path
        end
    end

    def create_db
        @db = SQLite3::Database.new(@db_path)
    end

    def create_table
        @db.execute('
            CREATE TABLE "events" (
                "id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
                "show" boolean DEFAULT 1,
                "birthday" boolean,
                "nameday" boolean,
                "payment" boolean,
                "year" integer,
                "month" integer,
                "day" integer,
                "name" varchar(255)
            )
        ')
    end

    def insert_rows
        puts 'Inserting events'

        insert_header = 'INSERT INTO "events" ("show", "birthday", "nameday", "payment", "year", "month", "day", "name") VALUES (:show, :birthday, :nameday, :payment, :year, :month, :day, :name)'
        insert_rows   = events()

        insert_rows.each do |row|
            @db.execute insert_header, row
        end
    end
end

creator = Creator.new
creator.create
