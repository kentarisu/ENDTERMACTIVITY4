USE endterm_activity4;

INSERT INTO users (email, password_hash, display_name)
VALUES
('demo@flicklog.app', '$2y$10$Wguk.yZJOHu0ErGvu0xBbuTaItg4bm/FbW1.xoQgQki71oJKVQ1xO', 'Demo Critic')
ON DUPLICATE KEY UPDATE display_name = VALUES(display_name);

SET @demo_user_id = (SELECT id FROM users WHERE email = 'demo@flicklog.app');

INSERT INTO entries (user_id, title, release_year, review, rating, status, poster_url)
VALUES
(@demo_user_id, 'The Grand Budapest Hotel', 2014, 'A whimsical ride with sharp humor.', 9, 'watched', NULL),
(@demo_user_id, 'Past Lives', 2023, 'Beautiful meditation on fate and love.', 8, 'watched', NULL)
ON DUPLICATE KEY UPDATE review = VALUES(review);

