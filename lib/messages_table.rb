class MessagesTable
  attr_reader :database_connection

  def initialize(database_connection)
    @database_connection = database_connection
  end

  def create_message(message)
    insert_message_sql = <<-SQL
    INSERT INTO messages (message)
    VALUES ('#{message}')
    RETURNING ID
    SQL

    @database_connection.sql(insert_message_sql)
  end

  def all
    database_connection.sql("SELECT * FROM messages")
  end

  def find(id)
    @database_connection.sql("SELECT * FROM messages WHERE id = #{id}").first
  end

  def update(id, message)
    update_sql = <<-SQL
    UPDATE messages
    SET message = '#{message}'
    WHERE id = #{id};
    SQL
    database_connection.sql(update_sql)
  end

  def delete(id)
    delete_sql = <<-SQL
    DELETE from messages
    WHERE id = #{id}
    SQL
    database_connection.sql(delete_sql)
  end

  def find_likes(id)
    @database_connection.sql("SELECT likes FROM messages WHERE id = #{id}").first
  end

  def add_like(id, num)
    add_likes = <<-SQL
    UPDATE messages
    SET likes = #{num}
    WHERE id = #{id};
    SQL
    database_connection.sql(add_likes)
  end

  def delete_like(id, num)
    delete_likes = <<-SQL
    UPDATE messages
    SET message = #{num}
    WHERE id = #{id}
    SQL
    database_connection.sql(delete_likes)
  end


end
