WITH st_table AS
(
SELECT
    U.username,
    moviename,
    rating
FROM
/*-------------------------------------------------------------------------------------------------------------------
  Запрос Big_query выдаст в результате таблицу с полями:
    - Пользователь_1
    - Фильм_А (просмотренный Пользователем_1)
    - Другой пользователь, посмотревший этот фильм (Пользователь_2) 
    - Фильм_Б, который смотрел Пользователь_2, но не смотрел Пользователь_1
    - Рейтинг Фильма_Б, равный количеству всех просмотров Фильма_Б.
  Запрос выдаст все такие возможные строки.
*/
    (SELECT
        customer,
        movie_customer_watched,
        another_viewer,
        h.movie_id AS applicant_movie,
        rating.count_users AS rating
    FROM
        /*-------------------------------------------------------------------------------------------------------------- 
          Запрос query1 выдаст таблицу: Пользователь_1 - Фильм_А - Пользователь_2.
          Пользователь_1 смотрел Фильм_A.
          Пользователь_2 тоже смотрел Фильм_А.
        */
        (SELECT
            h1.user_id AS customer,
            h1.movie_id AS movie_customer_watched,
            h2.user_id AS another_viewer
        FROM
            history AS h1
        JOIN 
            history AS h2 
        USING(movie_id)
        WHERE
            h1.user_id <> h2.user_id
    ) AS query1

    /*-------------------------------------------------------------------------------------------------------------------*/

	JOIN 
    	/*
          Эту таблицу джойним с той целью, чтобы найти 
          те фильмы, которые смотрели Пользователи_2,  
          но не смотрели соответствующие Пользователи_1.
        */
    	history AS h
	ON
    	h.user_id = another_viewer 
    	AND
    	/* 
          Здесь проверяется, что среди добавляемых строк нет 
    	  строки с полем id фильма, который Пользователь_1 уже смотрел.
        */
    	movie_customer_watched <> h.movie_id

    /*-------------------------------------------------------------------------------------------------------------------*/

	JOIN 
    	/* 
          Эту таблицу джойним для того, чтобы получить рейтинги добавленных запросом выше фильмов.
        */
    	(SELECT
        	m.movie_id AS m_id,
        	COUNT(username) AS count_users
    	FROM
    	    users AS u
    	JOIN 
            history AS h
    	ON
    	    h.user_id = u.user_id
    	JOIN 
            movies AS m
    	ON
    	    m.movie_id = h.movie_id
    	GROUP BY
        	m.movie_id
		) AS rating
	ON m_id = h.movie_id   

	) AS Big_query


/*- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  Подключаем таблицу users для вывода имени пользователя.
*/
JOIN 
    users AS U
ON
    U.user_id = customer

/*- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  Подключаем таблицу movies для вывода названия фильма.
*/
JOIN
    movies AS M
ON 
    M.movie_id = applicant_movie
/*- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*/

)


SELECT 
	T.username,
    moviename,
    Q.rating
FROM 
	st_table as T
    JOIN
    (SELECT username, MAX(rating) AS rating
     FROM st_table
     GROUP BY username
     ) AS Q
     ON T.username = Q.username
       AND T.rating = Q.rating