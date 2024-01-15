CREATE EXTENSION plpython3;

CREATE OR REPLACE FUNCTION get_chat_info(chat_id INT)
  RETURNS Chats
AS $$
DECLARE
    chat_info Chats;
BEGIN
    SELECT * INTO chat_info
    FROM Chats
    WHERE chatID = chat_id;
    
    IF FOUND THEN
        RETURN chat_info;
    ELSE
        RETURN NULL;
    END IF;
END;
$$ LANGUAGE plpgsql;

explain analyze
SELECT * FROM get_chat_info(1);

-- Определяемая пользователем скалярная функция
CREATE OR REPLACE FUNCTION get_chat_info(chat_id INT)
  RETURNS Chats
AS $$
    import plpy

    res = plpy.execute(f" \
        SELECT * \
        FROM Chats  \
        WHERE chatID = {chat_id};")

    if res:
        return res[0]
    else:
        return None
$$ LANGUAGE plpython3u;

explain analyze
SELECT * FROM get_chat_info(1);

-- Пользовательская агрегатная функция
CREATE OR REPLACE FUNCTION find_extreme_age_users()
RETURNS TABLE(age_max float, age_min float)
AS $$
    res = plpy.execute("SELECT MAX(date_part('year', age(current_date, dateOfBirthday))) as age_max, \
                               MIN(date_part('year', age(current_date, dateOfBirthday))) as age_min \
                       FROM Users;")
  
    yield res[0]
$$ LANGUAGE plpython3u;

SELECT * FROM find_extreme_age_users();

--Определяемая пользователем табличная функция
drop function get_users_between(min_age int, max_age int);
CREATE OR REPLACE FUNCTION get_users_between(min_age int, max_age int)
RETURNS TABLE (user_ID int, user_name varchar, age float)
AS $$
    res = plpy.execute(f"select userid, firstname, date_part('year', age(current_date, dateOfBirthday)) as age\
					   from users\
					   where date_part('year', age(current_date, dateOfBirthday))\
					   between {min_age} and {max_age};")
    for elem in res:
        yield(elem['userid'], elem['firstname'], elem['age'])
$$ LANGUAGE plpython3u;

select * from get_users_between(20, 30);

-- Хранимая процедура
create or replace procedure update_username(_id int, new_name varchar)
as $$
    query = plpy.prepare("update users set firstname = $2\
						 where userid = $1", ["int", "varchar"])
    plpy.execute(query, [_id, new_name])
$$ language plpython3u;

call update_username(1, 'New_name');
select * from users;

-- Триггер
create table user_audits (
    usr_id int,
    usr_name varchar
);

create or replace function log_update_usr()
returns trigger 
as $$
query = plpy.prepare("insert into user_audits values ($1, $2);", ["int", "text"])

_new = TD['new']
_old = TD['old']
if _new["firstname"] != _old["firstname"]:
  plpy.execute(query, [_old["userid"], _old["firstname"]])
return 'Modify'
$$ language plpython3u;
--drop function log_update_usr();
--drop trigger usr_update on users;
create trigger usr_update 
after update on users
for each row 
execute procedure log_update_usr();

update users
set firstname = 'user2'
where userid = 1;

select * from users;
select * from user_audits;

-- Определяемый пользователем тим данных
create type age_statistics as (
	age_max float,
	age_min float
);

CREATE OR REPLACE FUNCTION find_extreme_age_users2()
RETURNS setof age_statistics
AS $$
    max_age = None
    min_age = None

    res = plpy.execute("SELECT date_part('year', age(current_date, dateOfBirthday)) as age\
                       FROM Users;")
	
    for row in res:
        user_age = row['age']

        if max_age is None or user_age > max_age:
            max_age = user_age

        if min_age is None or user_age < min_age:
            min_age = user_age
    yield (max_age, min_age)
$$ LANGUAGE plpython3u;

-- Пример использования агрегатной функции для нахождения самого старшего и самого младшего пользователя
SELECT * FROM find_extreme_age_users();
