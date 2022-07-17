
CREATE TABLE IF NOT EXISTS posts (
  id SERIAL PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  content TEXT NOT NULL,
  creator_id SERIAL NOT NULL,
  created_at TIMESTAMP NOT NULL,
  updated_at TIMESTAMP NOT NULL
);

CREATE TABLE IF NOT EXISTS comments (
  id SERIAL PRIMARY KEY,
  post_id SERIAL NOT NULL,
  content TEXT NOT NULL,
  creator_id SERIAL NOT NULL,
  created_at TIMESTAMP NOT NULL,
  updated_at TIMESTAMP NOT NULL
);

CREATE TABLE IF NOT EXISTS tags (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL
);

CREATE TABLE IF NOT EXISTS post_tags (
  post_id SERIAL NOT NULL,
  tag_id SERIAL NOT NULL
);

CREATE TABLE IF NOT EXISTS creator (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  email VARCHAR(255) NOT NULL,
  password TEXT NOT NULL
);


INSERT INTO creator (name, email, password) VALUES 
('admin', 'admin@email.com', 'admin');

INSERT INTO posts (title, content, creator_id, created_at, updated_at) VALUES 
('Post 1', 'Content 1', 1, '2020-01-01 00:00:00', '2020-01-01 00:00:00'),
('Post 2', 'Content 2', 1, '2020-01-01 00:00:00', '2020-01-01 00:00:00'),
('Post 3', 'Content 3', 1, '2020-01-01 00:00:00', '2020-01-01 00:00:00');