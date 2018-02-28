require_relative 'aa_questions'

class QuestionLikes
  attr_accessor :id, :user_id, :question_id

  def self.all
    data = QuestionDBConnection.instance.execute("SELECT * FROM question_likes")
    data.map { |datum| QuestionLikes.new(datum) }
  end


  def initialize(options)
    @id = options['id']
    @user_id = options['user_id']
    @question_id = options['question_id']
  end

  def self.likers_for_question_id(question_id_given)
    users = QuestionDBConnection.instance.execute(<<-SQL, question_id_given)
      SELECT
        fname, lname
      FROM
        users
        JOIN question_likes ON question_likes.user_id = users.id
      WHERE
        question_id = ?
    SQL

    return nil unless users.length > 0

    users.map {|el| User.new(el)}
  end

  def self.num_likes_for_question_id(question_id_given)
    likes = QuestionDBConnection.instance.execute(<<-SQL, question_id_given)
      SELECT
        COUNT(question_likes.user_id)
      FROM
        question_likes
      WHERE
        question_id = ?
    SQL

    likes.first.values.first
  end

  def self.liked_questions_for_user_id(user_id_given)
    questions = QuestionDBConnection.instance.execute(<<-SQL, user_id_given)
      SELECT
        questions.id, title, body, questions.user_id
      FROM
        questions
        JOIN question_likes ON question_likes.question_id = questions.id
      WHERE
        question_likes.user_id = ?
    SQL

    return nil unless questions.length > 0

    questions.map {|el| Question.new(el)}
  end

  def self.most_liked_questions(n)
    questions = QuestionDBConnection.instance.execute(<<-SQL, n)
    SELECT
      title, body, questions.user_id
    FROM
      questions
      JOIN question_likes ON question_likes.question_id = questions.id
    GROUP BY
      questions.id
    HAVING
      COUNT(question_likes.user_id) > 0
    LIMIT
    ?
    SQL

    return nil unless questions.length > 0

    questions.map {|el| Question.new(el)}
    end
end
