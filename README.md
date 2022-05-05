# sql-queries

SQL запрос, который реализует логику алгоритма рекомендаций фильмов к просмотру, которые пользователи еще не смотрели.

На входе: База Данных с полями: Пользователь, Фильм

Логика такая:
-Допустим пользователь просмотрел Фильм A
-Определяем кто еще из пользователей смотрел Фильм A
-Определяем какие еще фильмы смотрели все эти пользователи
-Группируем найденные фильмы по наименованию и определяем для каждого кол-во пользователей, которые его смотрели
-Чем больше пользователей его посмотрело, тем выше его рейтинг в списке рекомендаций
-Итоговый запрос учитывает в модели рекомендаций все фильмы, которые посмотрели все пользователи
-На выходе таблица: Пользователь, Фильм для рекомендации, Рейтинг рекомендации
