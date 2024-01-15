-- Создаем таблицу Employee
DROP TABLE Employee
CREATE TABLE Employee (
    id SERIAL,
    FIO VARCHAR(255) NOT NULL,
    status TEXT NOT NULL,
    date_of_status DATE NOT NULL
);

-- Вставляем данные в таблицу Employee
INSERT INTO Employee (id,FIO, status, date_of_status) VALUES
    (1, 'Иванов Иван Иванович', 'Работа offline', '2022-12-12'),
    (1, 'Иванов Иван Иванович', 'Работа offline', '2022-12-13'),
    (1, 'Иванов Иван Иванович', 'Больничный', '2022-12-14'),
    (1, 'Иванов Иван Иванович', 'Больничный', '2022-12-15'),
    (1, 'Иванов Иван Иванович', 'Удаленная работа', '2022-12-16'),
	(1, 'Иванов Иван Иванович', 'Работа offline', '2022-12-17'),
	(1, 'Иванов Иван Иванович', 'Больничный', '2022-12-18'),
    (2, 'Петров Петр Петрович', 'Работа offline', '2022-12-12'),
    (2, 'Петров Петр Петрович', 'Работа offline', '2022-12-13'),
    (2, 'Петров Петр Петрович', 'Удаленная работа', '2022-12-14'),
    (2, 'Петров Петр Петрович', 'Удаленная работа', '2022-12-15'),
    (2, 'Петров Петр Петрович', 'Работа offline', '2022-12-16');
DROP VIEW Employee_Versions;
-- Создаем view Employee_Versions для версионного схлопывания
CREATE OR REPLACE VIEW Employee_Versions AS
SELECT id, FIO, MIN(date_of_status) AS date_from, MAX(date_of_status) AS date_to, status
FROM (SELECT id, FIO, status, date_of_status,
        ROW_NUMBER() OVER (PARTITION BY id, FIO ORDER BY date_of_status) - 
        ROW_NUMBER() OVER (PARTITION BY id, FIO, status ORDER BY date_of_status) AS grp
    FROM Employee
) AS StatusGroups
GROUP BY id, FIO, status, grp
ORDER BY id, date_from;


-- Выводим результат
SELECT * FROM Employee_Versions;
