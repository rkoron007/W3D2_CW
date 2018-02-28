DROP TABLE IF EXISTS users;

CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  fname TEXT NOT NULL,
  lname TEXT NOT NULL
);

DROP TABLE IF EXISTS questions;

CREATE TABLE questions (
  id INTEGER PRIMARY KEY,
  title TEXT NOT NULL,
  body TEXT NOT NULL,
  user_id  INTEGER NOT NULL,

FOREIGN KEY (user_id) REFERENCES users(id)
);


DROP TABLE IF EXISTS question_follows;

CREATE TABLE question_follows (
  id INTEGER PRIMARY KEY,
  user_id  INTEGER NOT NULL,
  question_id  INTEGER NOT NULL,

FOREIGN KEY (user_id) REFERENCES users(id),
FOREIGN KEY (question_id) REFERENCES questions(id)
);

DROP TABLE IF EXISTS replies;

CREATE TABLE replies (
  id INTEGER PRIMARY KEY,
  body TEXT NOT NULL,
  user_id  INTEGER NOT NULL,
  question_id  INTEGER NOT NULL,
  parent_reply_id INTEGER,

FOREIGN KEY (user_id) REFERENCES users(id),
FOREIGN KEY (question_id) REFERENCES questions(id),
FOREIGN KEY (parent_reply_id) REFERENCES replies(id)
);


DROP TABLE IF EXISTS question_likes;

CREATE TABLE question_likes (
  id INTEGER PRIMARY KEY,
  user_id  INTEGER NOT NULL,
  question_id  INTEGER NOT NULL,


FOREIGN KEY (user_id) REFERENCES users(id),
FOREIGN KEY (question_id) REFERENCES questions(id)
);



INSERT INTO
  users (fname, lname)
VALUES
  ('Arthur', 'Miller'),
  ('Homer','Simpson'),
  ('Bob', 'Bobby');



INSERT INTO
  questions (title, body, user_id)
VALUES
  ('post1?', 'this is a post1?', (SELECT id FROM users WHERE fname = 'Arthur')),
  ('post2?', 'this is a post2?', (SELECT id FROM users WHERE fname = 'Homer')),
  ('post3?', 'this is a post3?', (SELECT id FROM users WHERE fname = 'Bob'));

INSERT INTO
  question_follows (user_id, question_id)
VALUES
  ((SELECT id FROM users WHERE fname = 'Arthur'), (SELECT id FROM questions WHERE title = 'post1?')),
  ((SELECT id FROM users WHERE fname = 'Arthur'), (SELECT id FROM questions WHERE title = 'post2?')),
  ((SELECT id FROM users WHERE fname = 'Arthur'), (SELECT id FROM questions WHERE title = 'post3?')),
  ((SELECT id FROM users WHERE fname = 'Homer'), (SELECT id FROM questions WHERE title = 'post1?')),
  ((SELECT id FROM users WHERE fname = 'Homer'), (SELECT id FROM questions WHERE title = 'post2?')),
  ((SELECT id FROM users WHERE fname = 'Bob'), (SELECT id FROM questions WHERE title = 'post1?'));


INSERT INTO
  replies (user_id, body, question_id, parent_reply_id)
VALUES
  ((SELECT id FROM users WHERE fname = 'Arthur'), 'Parent_reply1',(SELECT id FROM questions WHERE title = 'post1?'), NULL),
  ((SELECT id FROM users WHERE fname = 'Homer'), 'Parent_reply2', (SELECT id FROM questions WHERE title = 'post2?'), NULL),
    ((SELECT id FROM users WHERE fname = 'Bob'), 'Parent_reply3',(SELECT id FROM questions WHERE title = 'post3?'), NULL);
INSERT INTO
  replies (user_id, body, question_id, parent_reply_id)
VALUES
  ((SELECT id FROM users WHERE fname = 'Homer'), 'child_reply1 to post1',(SELECT id FROM questions WHERE title = 'post1?'), (SELECT id FROM replies WHERE body = 'Parent_reply1')),
  ((SELECT id FROM users WHERE fname = 'Bob'), 'child_reply2 to post1', (SELECT id FROM questions WHERE title = 'post1?'), (SELECT id FROM replies WHERE body = 'Parent_reply1')),
  ((SELECT id FROM users WHERE fname = 'Arthur'), 'child relpy1 to Parent_reply2',(SELECT id FROM questions WHERE title = 'post3?'),(SELECT id FROM replies WHERE body = 'Parent_reply2'));


  INSERT INTO
    question_likes (user_id, question_id)
  VALUES
    ((SELECT id FROM users WHERE fname = 'Arthur'), (SELECT id FROM questions WHERE title = 'post1?')),
    ((SELECT id FROM users WHERE fname = 'Arthur'), (SELECT id FROM questions WHERE title = 'post2?')),
    ((SELECT id FROM users WHERE fname = 'Homer'), (SELECT id FROM questions WHERE title = 'post1?')),
    ((SELECT id FROM users WHERE fname = 'Homer'), (SELECT id FROM questions WHERE title = 'post2?')),
    ((SELECT id FROM users WHERE fname = 'Bob'), (SELECT id FROM questions WHERE title = 'post1?'));
