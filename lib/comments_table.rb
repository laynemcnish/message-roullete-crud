class CommentsTable
  attr_reader :database_connection

  def initialize(database_connection)
    @database_connection = database_connection
  end

  def create_comment(message_id, comment)
    insert_comment_sql = <<-SQL
    INSERT INTO comments (message_id, comment)
    VALUES (#{message_id}, '#{comment}')
    SQL

    @database_connection.sql(insert_comment_sql)
  end

  def all
    database_connection.sql("SELECT * FROM comments")
  end

  def find(id)
    @database_connection.sql("SELECT * FROM comments WHERE message_id = #{id}").first
  end


end
