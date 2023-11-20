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

-- Многооператорная функция
-- Эта функция возвращает набор таблиц в зависимости от входных параметров. 
-- Например, список чатов для данного пользователя и его сообщений. (она вернет список чатов пользователя и сообщений в этих чатах.)
CREATE OR REPLACE FUNCTION GetUserChatsAndMessages(userId INT) RETURNS TABLE (
    chatId INT,
    chatName VARCHAR(100),
    messageId INT,
    messageText VARCHAR(100),
    dateSent DATE
) AS $$
BEGIN
    RETURN QUERY
    SELECT C.chatID, C.chatName, M.messageID, M.messageText, M.dateSent
    FROM Chats C
    JOIN ChatMembers CM ON C.chatID = CM._chatID -- объединяем 3 таблицы
    JOIN Messages M ON C.chatID = M.chatID
    WHERE CM._userID = userId;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM GetUserChatsAndMessages(10);

-- Рекурсивная функция
-- Рекурсивная функция может использоваться для выполнения действий, требующих итерации или поиска в глубину в 
-- структурах данных, таких как деревья чатов или комментариев. В этом примере мы будем использовать рекурсивную 
-- функцию для поиска всех подчатов в чате.
--DROP FUNCTION RecursiveSubChats(INT);
CREATE OR REPLACE FUNCTION RecursiveSubChats(_chatId INT) RETURNS TABLE (
    subChatId INT,
    chatName VARCHAR(100)
) AS $$
BEGIN
    RETURN QUERY
    WITH RECURSIVE SubChats AS (
        SELECT C1.chatID, C1.chatName
        FROM Chats as C1
        WHERE C1.chatID = _chatId
    )
    SELECT S.chatID, S.chatName FROM SubChats S;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM RecursiveSubChats(20);

-- Хранимая процедура без параметров или с параметрами
-- В этой процедуре мы можем создать новый чат или добавить нового пользователя в существующий чат. 
-- Если вы хотите использовать параметры, вы можете передавать идентификаторы пользователя, чата и 
-- другие данные в качестве параметров.
DROP PROCEDURE CreateChat(INT, VARCHAR(100), INT, INT, INT, VARCHAR(100));
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
    CALL CreateChat(15, 'Joseph Cole', 1, 5, chatId, chatName);
    RAISE NOTICE 'Создан чат с chatID: % и chatName: %', chatId, chatName;
END $$;

-- Рекурсивная хранимая процедура или хранимая процедур с рекурсивным ОТВ:
-- Рекурсивная процедура для получения всех сообщений между двумя пользователями
CREATE OR REPLACE FUNCTION get_messages(sender_id int, receiver_id int, depth int default 0) RETURNS TABLE (
    message_id int,
    message_text varchar(100),
    sender_name varchar(100),
    receiver_name varchar(100)
) AS $$
BEGIN
    IF depth > 30 THEN
    	RETURN;
    END IF;
    IF sender_id = receiver_id THEN
        RETURN QUERY SELECT m.messageID, m.messageText, s.firstName, r.firstName
        FROM Messages m
        INNER JOIN users s ON m.senderID = s.userID
        INNER JOIN users r ON m.receiverID = r.userID
        WHERE (m.senderID = sender_id AND m.receiverID = receiver_id)
        OR (m.senderID = receiver_id AND m.receiverID = sender_id)
        ORDER BY m.messageID;
    ELSE
        RETURN QUERY SELECT m.messageID, m.messageText, s.firstName, r.firstName
        FROM messages m
        INNER JOIN users s ON m.senderID = s.userID
        INNER JOIN users r ON m.receiverID = r.userID
        WHERE (m.senderID = sender_id AND m.receiverID = receiver_id)
        OR (m.senderID = receiver_id AND m.receiverID = sender_id)
        ORDER BY m.messageID;
        RETURN QUERY SELECT * FROM get_messages(sender_id, receiver_id, depth + 1);
    END IF;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM get_messages(1, 1);

-- Хранимая процедура с курсором
CREATE OR REPLACE PROCEDURE GetChatMessagesProcedure(IN _chatId INT)
AS $$
DECLARE
    chatCursor CURSOR FOR
    SELECT messageId, senderId, messageText, dateSent
    FROM Messages
    WHERE chatId = _chatId;
    
    messageRecord RECORD;
BEGIN
    OPEN chatCursor;

    -- Начало итерации по результатам
    LOOP
        FETCH chatCursor INTO messageRecord;
        EXIT WHEN NOT FOUND; -- Выход из цикла, когда больше нет данных

        RAISE NOTICE 'MessageID: %, SenderID: %, Text: %, DateSent: %', messageRecord.messageID, messageRecord.senderID, messageRecord.messageText, messageRecord.dateSent;

    END LOOP;

    CLOSE chatCursor;
END;
$$ LANGUAGE plpgsql;

CALL GetChatMessagesProcedure(5);

CREATE OR REPLACE PROCEDURE GetTableMetadata(IN tableName VARCHAR(100))
AS $$
DECLARE
    columnInfo RECORD;
BEGIN
    FOR columnInfo IN
        SELECT column_name, data_type
        FROM information_schema.columns
        WHERE table_name = tableName
    LOOP
        -- Выполняйте необходимые действия с метаданными столбцов.
        -- Например, можно выводить информацию о каждом столбце.
        RAISE NOTICE 'Столбец: %, Тип данных: %', columnInfo.column_name, columnInfo.data_type;
    END LOOP;
END;
$$ LANGUAGE plpgsql;

CALL GetTableMetadata('users');

CREATE OR REPLACE FUNCTION AfterInsertMessage() RETURNS TRIGGER AS $$
BEGIN
    CREATE TEMP TABLE Notifications(
        id int,
        userID int, 
        message varchar(100));
    -- Ваш код для обработки вставки сообщения, например, отправка уведомлений.
    -- Здесь вы можете определить, какие действия выполнить после вставки сообщения.
    
    -- Пример: Отправка уведомления
    -- Предположим, у вас есть таблица "Notifications" для уведомлений.
    INSERT INTO Notifications (userID, message) VALUES (5, 'Новое сообщение в чате');
    RAISE NOTICE 'Уведомление создано для пользователя с ID: %', NEW.senderID;
    DROP TABLE Notifications;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER AfterInsertMessageTrigger
AFTER INSERT ON Messages
FOR EACH ROW
EXECUTE FUNCTION AfterInsertMessage();

INSERT INTO Messages(senderID, messageText)
VALUES (27, 'Тест');

-----------
CREATE OR REPLACE VIEW ChatView AS
SELECT *
FROM Messages;

CREATE OR REPLACE FUNCTION InsteadOfInsertChatMessage() RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO Messages(senderId, messageText)
    VALUES (NEW.sender, NEW.MessageText);
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER InsteadOfInsertChatMessageTrigger
INSTEAD OF UPDATE ON ChatView
FOR EACH ROW
EXECUTE FUNCTION InsteadOfInsertChatMessage();

INSERT INTO ChatView(senderId, messageText) VALUES (1, 'Привет');
SELECT * FROM ChatView;

