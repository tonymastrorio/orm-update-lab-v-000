require_relative "../config/environment.rb"

class Student
    attr_accessor :name, :grade
    attr_reader :id

    def initialize(name, grade, id=nil)
        @name = name
        @grade = grade
        @id = id
    end

    def self.create_table
        sql = "CREATE TABLE students(id INTEGER PRIMARY KEY,
        name TEXT, grade TEXT)"

        DB[:conn].execute(sql)
    end

    def self.drop_table
        sql = "DROP TABLE IF EXISTS students"

        DB[:conn].execute(sql)
    end

    def save
        if self.id
            self.update
        else
            sql = "INSERT INTO students(name, grade) VALUES (?, ?)"

            DB[:conn].execute(sql, self.name, self.grade)

            @id = DB[:conn].execute("SELECT last_insert_rowid() FROM 
                students")[0][0]
        end
    end

    def self.create(name, grade)
        student = Student.new(name, grade)
        student.save
        student
    end 

    def self.new_from_db(row)
        student = Student.new(row[1], row[2], row[0])
    end

    def self.find_by_name(name)
        sql = "SELECT * FROM students WHERE name = ?"

        row = DB[:conn].execute(sql, name)[0]
        new_from_db(row)
    end

    def update
        sql = "UPDATE students SET name=?, grade=? WHERE id=?"
        DB[:conn].execute(sql, self.name, self.grade, self.id)
    end

end
