delete from orders;
delete from sender;
delete from typesWork;

\copy orders from '/home/pante/Desktop/Pante/Data_Base/rk1/order.csv' delimiter ';' csv header;
\copy sender from '/home/pante/Desktop/Pante/Data_Base/rk1/sender.csv' delimiter ';' csv header;
\copy typesWork from '/home/pante/Desktop/Pante/Data_Base/rk1/typesWork.csv' delimiter ';' csv header;