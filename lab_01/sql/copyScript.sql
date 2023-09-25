delete from Chats;
delete from Users;
delete from UserChat;
delete from Messages;

copy Users from ~/Data_Base/lab_01/users.csv
select count(*) as numOfElems from Users;
copy UserChat from ~/Data_Base/lab_01/conversation.csv
select count(*) as numOfElems from UserChat;
copy Chats from ~/Data_Base/lab_01/contacts.csv
select count(*) as numOfElems from Chats;
copy Messages from ~/Data_Base/lab_01/messages.csv
select count(*) as numOfElems from Messages;