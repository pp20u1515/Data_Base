DELETE FROM Chats;
DELETE FROM Users;
DELETE FROM Messages;
DELETE FROM ChatMembers;

\COPY Users FROM '/home/pante/Desktop/Pante/Data_Base/lab_03/data/users.csv' delimiter ';' csv header;
\COPY Chats FROM '/home/pante/Desktop/Pante/Data_Base/lab_03/data/chats.csv' delimiter ';' csv header;
\COPY Messages FROM '/home/pante/Desktop/Pante/Data_Base/lab_03/data/messages.csv' delimiter ';' csv header;
\COPY ChatMembers FROM '/home/pante/Desktop/Pante/Data_Base/lab_03/data/chatMembers.csv' delimiter ';' csv header;