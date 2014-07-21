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

end
