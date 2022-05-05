CREATE TABLE users(
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(15)
);

CREATE TABLE movies(
    movie_id INT PRIMARY KEY AUTO_INCREMENT,
    moviename VARCHAR(20)
);

CREATE TABLE history(
    history_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    movie_id INT,
    FOREIGN KEY (user_id) REFERENCES users (user_id) ON DELETE CASCADE,
    FOREIGN KEY (movie_id) REFERENCES movies (movie_id) ON DELETE CASCADE
);



/* 
  Для удобства внес тестовые данные 
*/
INSERT INTO users(username)
VALUES ('John'),('Peter'),('Seymour'),('Homer'),('Abu');

INSERT INTO movies(moviename)
VALUES ('Drive'),('Fargo'),('Terminator'),('Gran Torino'),('Oxygen');

INSERT INTO history(user_id, movie_id)
VALUES (1, 3), 
       (2, 3), 
       (3, 1), 
       (4, 2), 
       (5, 1),
       (2, 2), 
       (2, 1), 
       (4, 4), 
       (3, 4), 
       (1, 5)