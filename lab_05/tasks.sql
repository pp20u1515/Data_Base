-- Из таблиц базы данных, созданной в первой лабораторной работе, в JSON(Oracle, Postgres)
select row_to_json(u) 
from users u;

select row_to_json(m)
from messages m;

select row_to_json(c)
from chats c;

select row_to_json(cm)
from chatmembers cm;

-- Выполнить загрузку и сохранение JSON файла в таблицу.
copy (select row_to_json(u) from users u) to 'C:\msys64\home\pante\pp20u1515\Data_Base\lab_05\users.json';

create table users_copy(j json);
copy users_copy from 'C:\msys64\home\pante\pp20u1515\Data_Base\lab_05\users.json';
select * 
from users_copy;

--Создать таблицу, в которой будет атрибут(-ы) с типом JSON, или
--добавить атрибут с типом JSON к уже существующей таблице.
--Заполнить атрибут правдоподобными данными с помощью команд INSERT
--или UPDATE.
create table json_temp (
	data json
);
insert into json_temp(data) 
values ('{"user_name": "Klime", "characteristics":{"color": "white", "age": 18}}'),
	   ('{"user_name": "Jovan", "characteristics":{"color": "Black", "age": 27}}');
select *
from json_temp;

--Извлечь JSON фрагмент из JSON документа
select data->'user_name' from json_temp jt ;
	   
-- Извлечь значения конкретных узлов или атрибутов JSON документа.
select data->'characteristics'->'color' from json_temp jt ;	 

--Выполнить проверку существования узла или атрибута
create or replace function check_exists(json_row json, key varchar)
returns boolean
as $$
begin
    return (json_row->key) is not NULL;
end;
$$ language plpgsql;

select check_exists('{"user_name": "Klime", "characteristics":{"color": "white", "age": 18}}', 'characteristics');

-- Изменить JSON документ
update json_temp
set data = '{"user_name": "Jovan", "characteristics":{"color": "Black", "age": 27, "user_family": "Jovanovski"}}'
where data->>'user_name' = 'Jovan';

select * from json_temp;


--Разделить JSON документ на несколько строк по узлам
create temp table mytemptables AS
select *
from jsonb_to_recordset('[{"user_name": "Klime", "characteristics":{"color": "white", "age": 18}},
                          {"user_name": "Jovan", "characteristics":{"color": "Black", "age": 27}}]')
as data(user_name varchar, characteristics jsonb);

select * from mytemptables;

-- Защита
--DROP PROCEDURE CreateChat(INT, VARCHAR(100), INT, INT, INT, VARCHAR(100));
CREATE OR REPLACE PROCEDURE CreateChat(IN _chatID INT, IN _chatName VARCHAR(100), IN _adminUserId INT, IN _participantsCount INT,
OUT newChatInfo JSON)
AS $$
BEGIN
    INSERT INTO Chats (chatID, chatName, createdAt, adminUserId, participantsCount)
    VALUES (_chatID, _chatName, CURRENT_DATE, _adminUserId, _participantsCount)
    RETURNING json_build_object('chatID', _chatID, 'chatName', _chatName) INTO newChatInfo;
END;
$$ LANGUAGE plpgsql;

DO $$ 
DECLARE
    chatInfo JSON;
BEGIN
    CALL CreateChat(33, 'Joseph Cole', 1, 5, chatInfo);
    RAISE NOTICE 'Создан чат: %', chatInfo;
    EXECUTE 'COPY (SELECT ''' || chatInfo::text || ''') TO ''C:\msys64\home\pante\pp20u1515\Data_Base\lab_05\result.json''';
END $$;   