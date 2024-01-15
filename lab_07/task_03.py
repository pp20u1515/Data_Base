from peewee import *

connect = PostgresqlDatabase(
    database = 'chatapp',
    user = 'postgres',
    password = '2v7z998d',
    host = '127.0.0.1',
    port = '5432'
)

class BaseModel(Model):
	class Meta:
		database = connect
		
class Users(BaseModel):
	user_id = IntegerField(column_name = 'userid', primary_key = True)
	firstname = CharField(column_name = 'firstname')
	lastname = CharField(column_name = 'lastname')
	email = CharField(column_name = 'email')
	user_password = CharField(column_name = 'userpassword')
	date_of_birthday = DateField(column_name = 'dateofbirthday')
	user_city = CharField(column_name = 'usercity')
	user_date_registration = DateField(column_name = 'userdateregistration')
	class Meta:
		table_name = 'users'
		
class Messages(BaseModel):
	message_id = IntegerField(column_name = 'messageid', primary_key=True)
	chat_id = IntegerField(column_name = 'chatid')
	sender_id = IntegerField(column_name = 'senderid')
	receiver_id = IntegerField(column_name = 'receiverid')
	message_text = CharField(column_name = 'messagetext')
	date_sent = DateField(column_name = 'datesent')
	is_readed = BooleanField(column_name = 'isread')
	class Meta:
		table_name = 'messages'
		
class Chats(BaseModel):
	chat_id = IntegerField(column_name = 'chatid', primary_key=True)
	chat_name = CharField(column_name = 'chatname')
	created_at = DateField(column_name = 'createdat')
	admin_user_id = IntegerField(column_name = 'adminuserid')
	participants_count = IntegerField(column_name = 'participantscount')
	class Meta:
		table_name = 'chats'
		
class ChatMembers(BaseModel):
	chat_member_id = IntegerField(column_name = 'chatmemberid', primary_key=True)
	_user_id = IntegerField(column_name = '_userid')
	_chat_id = IntegerField(column_name = '_chatid')
	is_member = BooleanField(column_name = 'ismember')
	is_admin = BooleanField(column_name = 'isadmin')
	class Meta:
		table_name = 'chatmembers'
		
def query_01():
    # Выборка всех полей из таблицы Users для пользователя с user_id = 10
    user = Users.get(Users.user_id == 10)
    
    # Вывод результатов запроса
    print("User ID:", user.user_id)
    print("First Name:", user.firstname)
    print("Last Name:", user.lastname)
    print("Email:", user.email)
    print("User City:", user.user_city)
    print("User Date Registration:", user.user_date_registration)
	
def query_02():
	query = (Users.select(Users.firstname, Messages.message_text, Chats.chat_name)
             .join(Messages, on=(Users.user_id == Messages.receiver_id))
             .join(Chats, on=(Users.user_id == Chats.chat_id))
             )
	for row in query.dicts():
		print("First Name:", row['firstname'])
		print("Message Text:", row['message_text'])
		print("Chat Name:", row['chat_name'])
		print()
		
def insert_data():
    new_user = Users.create(
		user_id=40,
        firstname='John',
        lastname='Doe',
        email='john.doe@example.com',
        user_password='securepassword',
        date_of_birthday='1990-01-01',
        user_city='New York',
        user_date_registration='2022-01-01'
    )
	
def update_data():
    user_to_update = Users.get(Users.user_id == 1)
    user_to_update.firstname = 'UpdatedFirstName'
    user_to_update.save()
	
def delete_data():
    message_to_delete = Messages.get(Messages.chat_id == 3)
    message_to_delete.delete_instance()

def query_03():
	insert_data()
	update_data()
	delete_data()
	
def query_04(cursor):
    query = f"call {CreateChat}(%s, %s)"
    connect.execute_sql(query, ('value1', 'value2'))

# Пример использования   
def task_03():
	query_01()
	print()
	query_02()
	print()
	query_03()
	print()
	query_04
	
task_03()
	
