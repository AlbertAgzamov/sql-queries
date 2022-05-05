/* 
  Число зрителей каждого фильма
*/
SELECT m.movie_id AS m_id, COUNT(username) AS count_users
FROM users as u
INNER JOIN history AS h ON h.user_id = u.user_id
INNER JOIN movies AS m On m.movie_id = h.movie_id
GROUP BY m.movie_id
ORDER BY count_users DESC, moviename

/*
зрители и фильмы, которые они посмотрели
*/
SELECT username, moviename
FROM users 
INNER JOIN history ON users.user_id = history.user_id
INNER JOIN movies ON movies.movie_id = history.movie_id


SELECT history_id, user_id, username, moviename
FROM users AS u
INNER JOIN history USING(user_id)
INNER JOIN movies USING(movie_id)


