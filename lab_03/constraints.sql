alter table users
    add constraint userid primary key(userID),
    alter column firstName set not null,
    alter column lastName set not null,
    alter column email set not null,
    alter column userPassword set not null,
    alter column userDateRegistration set not null;

alter table Chats 
    add constraint chatid primary key(chatID),
    alter column createdAt set not null,
    alter column adminUserID set not null;

alter table ChatMembers
    add constraint chatmemberid primary key(chatMemberID),
    add constraint _userid foreign key (_userID) references Users(userid) on delete cascade,
    add constraint _chatid foreign key(_chatID) references Chats(chatID) on delete cascade;

alter table Messages 
    add constraint messageid primary key(messageID),
    add constraint ChatID_FK foreign key(chatID) references Chats(chatID) on delete cascade,
    add constraint SenderIDFK foreign key(senderID) references Users(userID) on delete cascade,
    alter column chatID set not null,
    alter column senderID set not null,
    alter column messageText set not null,
    alter column dateSent set not null;