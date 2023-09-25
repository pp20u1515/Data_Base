alter table Chats add constraint ChatsPK primary key(chatID);
alter table Users add constraint UsersPK primary key(userID);
alter table UserChat add constraint UserChatPK primary key(userChatID);
alter table Messages add constraint MessagesPK primary key(messageID);

alter table UserChat add constraint UsersIDFK foreign key(_userID) references Users(userID) on delete cascade;
alter table Chats add constraint ChatIDPF foreign key(adminUserID) references Users(userID) on delete cascade;
alter table UserChat add constraint ChatIDFK foreign key(_chatID) references Chats(chatID) on delete cascade;
alter table Messages add constraint ChatID_FK foreign key(chatID) references Chats(chatID) on delete cascade;
alter table Messages add constraint SenderIDFK foreign key(senderID) references Users(userID) on delete cascade;