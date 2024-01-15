DELETE FROM Chats;
DELETE FROM Users;
DELETE FROM Messages;
DELETE FROM ChatMembers;

\COPY Users FROM 'C:\msys64\home\pante\pp20u1515\Data_Base\lab_03\data\users.csv' delimiter ';' csv header;
\COPY Chats FROM 'C:\msys64\home\pante\pp20u1515\Data_Base\lab_03\data\chats.csv' delimiter ';' csv header;
\COPY Messages FROM 'C:\msys64\home\pante\pp20u1515\Data_Base\lab_03\data\messages.csv' delimiter ';' csv header;
\COPY ChatMembers FROM 'C:\msys64\home\pante\pp20u1515\Data_Base\lab_03\data\chatMembers.csv' delimiter ';' csv header;