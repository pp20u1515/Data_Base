DELETE FROM Chats;
DELETE FROM Users;
DELETE FROM Messages;
DELETE FROM ChatMembers;

\COPY Users FROM '/home/pante/Desktop/Pante/Data_Base/lab_02/users.csv' delimiter ';' csv header;
\COPY Chats FROM '/home/pante/Desktop/Pante/Data_Base/lab_02/chats.csv' delimiter ';' csv header;
\COPY Messages FROM '/home/pante/Desktop/Pante/Data_Base/lab_02/messages.csv' delimiter ';' csv header;
\COPY ChatMembers FROM '/home/pante/Desktop/Pante/Data_Base/lab_02/chatMembers.csv' delimiter ';' csv header;