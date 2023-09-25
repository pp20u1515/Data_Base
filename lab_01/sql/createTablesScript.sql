create database userChatRoom;

create table Users(
    userID int primary key,
    firstName varchar(100) not null,
    lastName varchar(100) not null,
    email varchar(100) not null,
    userPassword varchar(100) not null,
    dataOfBirthday date not null,
    userCity varchar(100),
    userDateRegistration date not null
);

create table ChatMembers(
    chatMemberID int,
    _userID int not null,
    _chatID int not null,
    isMember bool,
    isAdmin bool
);

create table Chats(
    chatID int primary key,
    chatName varchar(100) not null,
    createdAt date not null,
    adminUserID int not null
);

create table Messages(
    messageID int primary key,
    chatID int,
    senderID int,
    messageText varchar(100) not null,
    dateSent date not null
);  
