from py_linq import *
from peewee import *
# Создаем курсор - специальный объект для запросов и получения данных с базы

connect = PostgresqlDatabase(
    database = 'chatapp',
    user = 'postgres',
    password = 'lab01',
    host = '127.0.0.1',
    port = 5432
)

# Определяем базовую модель о которой будут наследоваться остальные
class BaseModel(Model):
    class Meta:
        database = connect  # соединение с базой, из шаблона выше

class Users(BaseModel):
    user_id = IntegerField(column_name = 'user_id')
    firstname = CharField(column_name = 'firstname')
    lastname = CharField(column_name = 'lastname')
    email = CharField(column_name = 'email')
    user_password = CharField(column_name = 'user_password')
    date_of_birthday = DateField(column_name = 'date_of_birthday')
    user_city = CharField(column_name = 'user_city')
    user_date_registration = DateField(column_name = 'user_date_registration')

    class Meta:
        table_name = 'users'

def query_01():
    print("")
    user = Users.get(Users.user_id == 10)
    print(user.user_id, user.firstname, user.lastname, user.email, \
          user.user_password, user.date_of_birthday, user.user_city, user.user_date_registration)