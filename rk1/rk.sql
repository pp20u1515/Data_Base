create database rk2;

create table teachers(
	id int primary key,
	fio varchar(100),
	teachers_degree varchar(100),
	department varchar(100)
);

create table topics(
	id int primary key,
	teacher varchar(100),
	topic varchar(100),
	foreign key(id) references teachers(id) on delete cascade
);

create table students(
	id int primary key,
	book_num int unique,
	fio varchar(100),
	faculty varchar(100),
	student_group int,
	foreign key(id) references teachers(id) on delete cascade
);

create table marks(
	id int primary key,
	book_num int,
	site_mark int,
	diplom_mark int,
	foreign key(book_num) references students(book_num) on delete cascade
);

insert into teachers values (1, 'Hannah Ross', 'young_teacher', 'FN'),
                           (2, 'Scott Stanley', 'docent', 'SGN'),
                           (3, 'Nicholas Sanders', 'docent', 'FN'),
                           (4, 'Patricia Klein', 'young_teacher', 'SGN'),
                           (5, 'Charles Smith', 'docent', 'FN'),
                           (6, 'Phillip Andersen', 'old_teacher', 'L'),
                           (7, 'David Watkins', 'young_teacher', 'L'),
                           (8, 'Jeff Cox', 'old_teacher', 'L'),
                           (9, 'Shannon Anderson', 'old_teacher', 'FN'),
                           (10, 'Tamara Mcintosh', 'young_teacher', 'L');	

insert into topics values (1, 'Hannah Ross', 'Mathemathic'),
                           (2, 'Scott Stanley', 'Psychology'),
                           (3, 'Nicholas Sanders', 'Mathemathic'),
                           (4, 'Patricia Klein', 'Psychology'),
                           (5, 'Charles Smith', 'Mathemathic'),
                           (6, 'Phillip Andersen', 'Physics'),
                           (7, 'David Watkins', 'Russian_language'),
                           (8, 'Jeff Cox', 'Music'),
                           (9, 'Shannon Anderson', 'Physics'),
                           (10, 'Tamara Mcintosh', 'Russian_language');
						   
insert into students values (1, 1, 'Elizabeth Beasley', 'FN', 55),
                           (2, 2, 'Nicole West', 'SGN', 56),
                           (3, 3, 'Michael Cruz', 'FN', 55),
                           (4, 4, 'Howard Johnson', 'SGN', 56),
                           (5, 5, 'Julie Snyder', 'FN', 56),
                           (6, 6, 'Christopher Keller', 'L', 57),
                           (7, 7, 'Donna Simpson', 'L', 57),
                           (8, 8, 'Lauren Sanchez', 'L', 57),
                           (9, 9, 'Valerie Cook', 'FN', 55),
                           (10, 10, 'James Roth', 'L', 57);	
						   
insert into marks values (1, 1, 5, 5),
                           (2, 2, 5, 5),
                           (3, 3, 4, 4),
                           (4, 4, 4, 4),
                           (5, 5, 3, 3),
                           (6, 6, 3, 3),
                           (7, 7, 3, 3),
                           (8, 8, 5, 5),
                           (9, 9, 4, 4),
                           (10, 10, 4, 4);	

--Инструкция select, использующая скалярные подзапросы в выражениях столбцов
-- В столбцах num_topics и num_students используются скалярные подзапросы, 
-- которые возвращают количество записей в таблицах "topics" и "students"
select id, fio, teachers_degree, department, (
    select count(*) 
	from topics 
	where id = teachers.id
  ) as num_topics,
  (
    select count(*) 
	from students 
	where id = teachers.id
  ) as num_students
from teachers;

-- Инструкция select, использующая вложенные подзапросы с уровнем вложености 
--  В этом запросе выбираются имена преподавателей из таблицы teachers. В столбце 
-- topic_count используется вложенный подзапрос, который возвращает количество предметов, 
-- преподаваемых данным преподавателем. В столбце student_count также используется вложенный 
-- подзапрос, который возвращает общее количество студентов из разных факультетов, 
-- зарегистрированных на курсах, которые преподаются данным преподавателем.
select t.fio, (
    select count(*)
    from topics
    where id = t.id and topic in (
        select topic
        from topics
        where id = t.id)) as topic_count, (
    						select count(*)
							from students
							where id in ( select id
							  			  from students
							  			  where faculty in (
										  select distinct faculty
										  from students))) AS student_count
from teachers t;

-- Инструкция select, использующая простое выражение case 
-- В этом запросе выбираются имена, степени и департаменты преподавателей из таблицы teachers. 
-- В столбце academic_rank присваивает каждому преподавателю соответствующий 
-- академический звание на основе его степени.
select fio, teachers_degree, department, case
    									when teachers_degree = 'young_teacher' then 'Assistant'
    									when teachers_degree = 'docent' then 'Associate professor'
    									when teachers_degree = 'old_teacher' then 'Professor'
    									else 'Unknown'
  										end as academic_rank
from teachers;

-- Этот запрос вернет количество уничтоженных триггеров.
create or replace function destroy_dml_triggers() 
return integer as $$
declare 
    trigger_count integer;
begin
    select count(*) into trigger_count
    from information_schema.triggers
    where trigger_schema not in ('pg_catalog', 'information_schema');
    
    execute 'DROP TRIGGER ALL ON ALL';
    
    return trigger_count;
end;
$$ language plpgsql;

create or replace view teachers_view as
select *
from teachers;

create trigger destroy_dml_triggers_trigger
instead of update on teachers_view
for each row
execute procedure destroy_dml_triggers();

						   
						   
						   
