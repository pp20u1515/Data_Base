-- Запрос 1
SELECT DISTINCT C1.userCity, C1.firstName
FROM Users AS C1 JOIN Users AS C2 ON C2.userCity = C1.userCity
WHERE C2.userID > C1.userID
AND C1.userCity = 'London'
ORDER BY C1.userCity, C1.firstName;

-- Запрос 2
SELECT DISTINCT userID, dateOfBirthday
FROM Users
WHERE dateOfBirthday BETWEEN '1997-01-01' AND '2000-06-10';

-- Запрос 3
SELECT DISTINCT messageText
FROM Messages JOIN Chats ON Chats.chatID = Messages.chatID
WHERE messageText LIKE '%smith%';

-- Запрос 4
SELECT userID, firstName, lastName, dateOfBirthday
FROM Users
WHERE userID IN (SELECT messageID
                    FROM Messages
                    WHERE messageText = 'smith');

-- Запрос 5
SELECT userID, firstName, lastName, userCity
FROM Users
WHERE EXISTS (SELECT messageID
        FROM Messages 
        WHERE chatID = 10
);                    

-- Запрос 6
SELECT chatMemberID, isMember, isAdmin
FROM ChatMembers
WHERE chatMemberID > ALL (SELECT chatID
                        FROM Chats
                        WHERE chatID = 15);

-- Запрос 7
SELECT senderID, COUNT(messageID) as totalMessages,
                AVG(LENGTH(messageText)) as averageMessageLength
FROM Messages
GROUP BY senderID;  

-- Запрос 8
SELECT messageID, messageText, (SELECT firstName || ' ' || lastName
                                FROM Users
                                WHERE userID = senderID) AS senderName
FROM Messages;                                

-- Запрос 9    
SELECT firstName, lastName,
        CASE 
        WHEN EXTRACT(YEAR FROM dateOfBirthday) = EXTRACT(YEAR FROM current_date) THEN 'This Year'
        WHEN EXTRACT(YEAR FROM dateOfBirthday) = EXTRACT(YEAR FROM current_date) - 1 THEN 'Last year'
        ELSE CAST(EXTRACT(YEAR FROM current_date) - EXTRACT(YEAR FROM dateOfBirthday) AS varchar(50)) || ' years ago'
        END AS "When"
FROM Users;

-- Запрос 10
SELECT messageID, messageText,
        CASE
                WHEN isRead = TRUE THEN 'Прочитано'
        ELSE 'Непрочитано'
    END AS MessageStatus
FROM Messages;

-- Запрос 11
CREATE TEMP TABLE TempMessageData AS
SELECT messageID, senderID, messageText
FROM Messages
WHERE isRead = TRUE;

SELECT * from TempMessageData;

-- Запрос 12
SELECT U.userID, U.userCity, AVG(messageCount) as avgMessageCount
FROM Users U
LEFT JOIN (
        SELECT senderID, COUNT(*) as messageCount
        FROM Messages M
        GROUP BY senderID
) AS Subquery
ON U.userID = Subquery.senderID
GROUP BY U.userID, U.userCity
ORDER BY U.userCity, U.userID;

-- Запрос 13
SELECT U.userID, U.firstName, U.lastName, U.userCity,
       chat_data.chatID, chat_data.participantsCount, chat_data.messageCount
FROM Users U
LEFT JOIN (
    SELECT C.chatID, C.participantsCount, COALESCE(M.messageCount, 0) AS messageCount
    FROM Chats C
    LEFT JOIN (
        SELECT chatID, COUNT(*) AS participantsCount
        FROM Messages
        GROUP BY chatID, senderID
    ) AS Subquery 
    ON C.chatID = Subquery.chatID
    LEFT JOIN (
        SELECT chatID, senderID, COUNT(*) as messageCount
        FROM Messages
        GROUP BY chatID, senderID
    ) AS M ON C.chatID = M.chatID
) AS chat_data
ON U.userID = chat_data.chatID;

-- Запрос 14
SELECT userCity, COUNT(*) as userCount
FROM Users
GROUP BY userCity;

-- Запрос 15
SELECT U.userCity, COUNT(C.chatID) as chatCount,
        SUM(C.participantsCount) as totalParticipants
FROM Users U
JOIN Chats C ON U.userID = C.chatID
GROUP BY U.userCity
HAVING SUM(C.participantsCount) > 20;     

-- Запрос 16  
INSERT INTO Messages (messageID, chatID, senderID, messageText,
dateSent, isRead)
VALUES (43, 30, 30, '6 pieces', '2023-10-21', TRUE);

-- Запрос 17
INSERT INTO Users (userID, firstName, lastName, email,
userPassword, dateOfBirthday, userCity, userDateRegistration)
SELECT DISTINCT senderID, 'DefaultFirstName', 'DefaultLastName', 'DefaultLastName',
messageText, dateSent, messageText, dateSent
FROM Messages
WHERE senderID NOT IN (SELECT userID
                        FROM Users);

SELECT * from Users;

-- Запрос 18
UPDATE Users
SET firstName = 'pante'
WHERE userCity = 'London';

SELECT * from Users;

-- Запрос 19
UPDATE Users
SET firstName = (SELECT messageText
                FROM Messages
                WHERE chatID = 7)
WHERE userCity = 'London';

SELECT * from Users;

-- Запрос 20
DELETE FROM Messages
WHERE messageID = 43;

-- Запрос 21
DELETE FROM Users
WHERE NOT EXISTS(SELECT 1
                FROM Messages
                WHERE Messages.senderID = Users.userID);

-- Запрос 22
WITH UsersFromLondon AS (
        SELECT userID, firstName, lastName
        FROM Users
        WHERE userCity = 'London'
)     

SELECT firstName, lastName
FROM UsersFromLondon;

-- Запрос 23
WITH RECURSIVE ChatMemberHierarchy AS (
    SELECT CM.chatMemberID, CM._userID, CM._chatID, 1 AS depth
    FROM ChatMembers CM
    WHERE CM._chatID IN (SELECT chatID
                        FROM Chats
                        WHERE chatName = 'Lisa Sharp')
)

-- Использование рекурсивного CTE в основном запросе
SELECT chatMemberID, _userID, _chatID, depth
FROM ChatMemberHierarchy;

-- Запрос 24
SELECT userID, firstName, lastName,
    MAX(userDateRegistration) OVER (PARTITION BY userID) AS maxRegistrationDate
FROM Users;

-- Запрос 25
WITH AllDubl AS
(
        SELECT *
        FROM Users

        UNION ALL

        SELECT *
        FROM Users
),

Deliting AS(
        SELECT * , row_number() over (PARTITION by userID) as num
        FROM AllDubl
)
SELECT * 
FROM Deliting
WHERE num = 1;