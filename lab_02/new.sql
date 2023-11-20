SELECT
    U.userID AS UserID,
    U.firstName AS FirstName,
    U.lastName AS LastName,
    C.chatName AS ChatName,
    M.messageText AS MessageText
FROM
    Users U
LEFT JOIN
    ChatMembers CM ON U.userID = CM._userID
LEFT JOIN
    Chats C ON CM._chatID = C.chatID
LEFT JOIN
    Messages M ON C.chatID = M.chatID
ORDER BY
    U.userID, C.chatID;
