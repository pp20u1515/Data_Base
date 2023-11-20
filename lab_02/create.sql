--DROP TABLE IF EXISTS ChatMembers;
--DROP TABLE IF EXISTS Messages;
--DROP TABLE IF EXISTS Users;
--DROP TABLE IF EXISTS Chats;

CREATE TABLE Users(
    userID int,
    firstName varchar(100),
    lastName varchar(100),
    email varchar(100),
    userPassword varchar(100),
    dateOfBirthday date,
    userCity varchar(100),
    userDateRegistration date
);

CREATE TABLE ChatMembers(
    chatMemberID int,
    _userID int,
    _chatID int,
    isMember bool,
    isAdmin bool
);

CREATE TABLE Chats(
    chatID int,
    chatName varchar(100),
    createdAt date,
    adminUserID int,
    participantsCount int
);

CREATE TABLE Messages(
    messageID int,
    chatID int,
    senderID int,
    messageText varchar(100),
    dateSent date,
    isRead bool
);  