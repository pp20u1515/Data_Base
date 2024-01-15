CREATE OR REPLACE FUNCTION checkChatMembers() RETURNS TRIGGER AS $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 
		FROM ChatMembers 
		WHERE _chatID = OLD._chatID) THEN
        DELETE FROM Chats
		WHERE chatID = OLD._chatID;
    END IF;
    
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER afterDeleteChatMember
AFTER DELETE ON ChatMembers
FOR EACH ROW
EXECUTE FUNCTION checkChatMembers();

delete from ChatMembers
where _chatID = 2;
select * from Chats;
drop trigger afterDeleteChatMember on ChatMembers;
