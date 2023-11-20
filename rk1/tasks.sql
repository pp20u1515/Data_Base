-- Выбираем столбцы _FIO(ФИО), _dateOfBirthday(дата рождения), _work(стаж)
-- из пересечения между таблицами orders и  typesWork где typesWorkID равен orderID,
-- упорядочивая ФИО, дата рождения и стаж по возростанию, имея стаж больше 5 
select _FIO, _dateOfBirthday, _work
from orders O join typesWork T on t.typesWorkID = O.orderID
group by _FIO, _dateOfBirthday, _work
having _work > 5;

-- Выбираем столбцы typesWorkID, workName
-- из пересечения  между таблицами typesWork и orders где orderID равен typesWorkID
-- упорядочивая название работы по  возростанию
select typesWorkID, workName
from typesWork tW join orders O on O.orderID = tW.typesWorkID
group by typesWorkID, workName;

update table orders
where orderID in (select senderID
                from sender
                where senderID = 5);

-- делаем update таблицы orders
-- изменяя ФИО на pante где orderID равен 5, полученый из 
-- senderId который равен 5 из таблицы sender
UPDATE orders
SET _FIO = 'pante'
WHERE orderID = (select senderID
                from sender
                WHERE senderID = 5);
select * from orders;