alter table orders
    add constraint orderID_pk primary key(orderID),
    add constraint fio_fk foreign key(_FIO) references typesWork(workName) on delete cascade,
    add constraint dateOfBirthday_fk foreign key(dateOfBirthday) references sender(dateOfBirthday) on delete cascade;

alter table sender 
    add constraint senderID_pk primary key(senderID),
    add constraint _fio_fk foreign key(FIO) references typesWork(workName) on delete cascade;

alter table typesWork
    add constraint typesWorkID_pk primary key(typesWorkID);    