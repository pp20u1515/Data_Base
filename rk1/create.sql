create database rk2;

create table typesWork(
    typesWorkID  int,
    workName text,
    dificulty text,
    instruments text
);

create table sender(
    senderID int,
    FIO text,
    dateOfBirthday date,
    work int,
    phone text
);

create table orders(
    orderID int,
    _FIO text,
    _dateOfBirthday date,
    _work int,
    _phone text
);