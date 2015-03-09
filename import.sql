CREATE TABLE users (
  id integer primary key,
  user text,
  comment text,
  password text,
  image text,
  created_at numeric
);
CREATE TABLE posts (
  id integer primary key,
  title text,
  explain text,
  url text,
  image text,
  created_at numeric
);
