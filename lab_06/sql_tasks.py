sql_task1 = """
--Скалярная функция
--Функция предназначена для вычисления количества непрочитанных сообщений для указанового пользователя
CREATE OR REPLACE FUNCTION GetUnreadMessageCount(userId INT) RETURNS INT AS $$
DECLARE
    unreadCount INT; -- обявляем счетчик
BEGIN
    SELECT COUNT(*) INTO unreadCount -- выбираем количество записей из таблицы Messages
    FROM Messages
    WHERE receiverId = userId AND isRead = false;
    
    RETURN unreadCount;
END;
$$ LANGUAGE plpgsql;

SELECT GetUnreadMessageCount(5) as unreadMessageCount;
"""

sql_task2 = """
-- Подставляемая табличная функция
-- Эта функция возвращает результаты запроса в виде таблицы. Например, список всех сообщений для данного чата.
CREATE OR REPLACE FUNCTION GetChatMessages(_chatId INT) RETURNS TABLE (
    messageId INT,
    senderId INT,
    messageText VARCHAR(100),
    dateSent DATE
) AS $$
BEGIN
    RETURN QUERY -- Этот оператор указывает, что функция будет возвращать результаты запроса как таблицу.
    SELECT M.messageID, M.senderID, M.messageText, M.dateSent
    FROM Messages as M
    WHERE M.chatID = _chatId;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM GetChatMessages(5);
"""

sql_task3 = """
-- Хранимая процедура без параметров или с параметрами
-- В этой процедуре мы можем создать новый чат или добавить нового пользователя в существующий чат. 
-- Если вы хотите использовать параметры, вы можете передавать идентификаторы пользователя, чата и 
-- другие данные в качестве параметров.
CREATE OR REPLACE PROCEDURE CreateChat(IN _chatID INT, IN _chatName VARCHAR(100), IN _adminUserId INT, IN _participantsCount INT,
OUT newChatID INT, OUT newChatName VARCHAR(100))
AS $$
BEGIN
    INSERT INTO Chats (chatID, chatName, createdAt, adminUserId, participantsCount)
    VALUES (_chatID, _chatName, CURRENT_DATE, _adminUserId, _participantsCount)
    RETURNING chatID, chatName INTO newChatID, newChatName;
END;
$$ LANGUAGE plpgsql;

DO $$ 
DECLARE
    chatId INT;
    chatName VARCHAR(100);
BEGIN
    CALL CreateChat(49, 'Joseph Cole', 1, 5, chatId, chatName);
END $$;
"""

protection = """
CREATE OR REPLACE FUNCTION GetMessage(userrId INT, chattID INT) RETURNS DATE AS $$
DECLARE
    sended DATE; 
BEGIN
    SELECT m.dateSent AS "Дата отправки"
    FROM Messages m
    JOIN ChatMembers cm ON m.chatID = cm._chatID
    WHERE cm._userID = userrID
    AND m.chatID = chattID;
    
    RETURN sended;
END;
$$ LANGUAGE plpgsql;

SELECT GetMessage(6, 6) as SendedMessage;

"""