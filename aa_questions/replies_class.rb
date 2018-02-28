require_relative 'aa_questions'

class Reply
  attr_accessor :id, :body, :user_id, :question_id, :parent_reply_id

  def self.all
    data = QuestionDBConnection.instance.execute("SELECT * FROM replies")
    data.map { |datum| Reply.new(datum) }
  end

  def self.find_by_user_id(user_id)


    reply = QuestionDBConnection.instance.execute(<<-SQL, user_id)
      SELECT
        *
      FROM
        replies
      WHERE
        user_id = ?
    SQL

    return nil unless reply.length > 0

    reply.map {|el| Reply.new(el)}
  end

  def self.find_by_question_id(question_id)


    reply = QuestionDBConnection.instance.execute(<<-SQL, question_id)
      SELECT
        *
      FROM
        replies
      WHERE
        question_id = ?
    SQL

    return nil unless reply.length > 0

    reply.map {|el| Reply.new(el)}
  end

  def initialize(options)
    @id = options['id']
    @body = options['body']
    @user_id = options['user_id']
    @question_id = options['question_id']
    @parent_reply_id = options['parent_reply_id']
  end

  def author
    QuestionDBConnection.instance.execute(<<-SQL, @user_id)
      SELECT
        fname, lname
      FROM
        users
      WHERE
        id = ?
    SQL
  end

  def question
    QuestionDBConnection.instance.execute(<<-SQL, @question_id)
      SELECT
        title
      FROM
        questions
      WHERE
        id = ?
    SQL
  end

  def parent_reply
    return nil if @parent_reply_id.nil?
    QuestionDBConnection.instance.execute(<<-SQL, @parent_reply_id)
      SELECT
        body
      FROM
        replies
      WHERE
        id = ?
    SQL
  end

  def child_reply
    QuestionDBConnection.instance.execute(<<-SQL, @id)
      SELECT
        body
      FROM
        replies
      WHERE
        parent_reply_id = ?
    SQL
  end
end
