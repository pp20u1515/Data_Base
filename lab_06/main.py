import psycopg2 as pg_lib
from sql_tasks import *

def connect_db(db_name, db_password, db_host = "localhost", db_user = "postgres"):
    connect = None
    try:
        connect = pg_lib.connect(
            host = db_host,
            database = db_name,
            user = db_user,
            password = db_password
        )
        connect.autocommit = True
    except pg_lib.OperationalError as e:
        print(f"Operational Error: {e}")
    except pg_lib.Error as e:
        print(f"PostgreSQL Error: {e}")
    except Exception as e:
        print(f"Unexpected Error: {e}")
    else:
        print("Connection successful!")
    
    return connect

def execute_scalar_query(cursor):
    cursor.execute(f"select count(*) from users")
    print(cursor.fetchone())

def execute_joins_query(cursor):
    query = f"select u.firstname, m.messagetext, c.chatname\
        from users u\
        join messages m on u.userid = m.receiverid\
        join chats c on u.userid = c.chatid"

    cursor.execute(query)
    row = cursor.fetchone()

    while row:
        print(row)
        row = cursor.fetchone()

def execute_cte_query(cursor):
    query = f"with usersFromLondon as (select userid, firstname, lastname\
            from users\
            where usercity = 'London')\
            select u.userid, u.firstname, u.lastname, m.datesent, m.messagetext,\
            sum(m.messageid) over (partition by u.userid) as total_date_sent\
            from usersFromLondon u\
            join messages m on u.userid = m.senderid"
    
    cursor.execute(query)
    row = cursor.fetchone()

    while row:
        print(row)
        row = cursor.fetchone()  

def execute_metadata_query(cursor):
    query = f"SELECT table_name\
            FROM information_schema.tables\
            WHERE table_schema = 'public';"
    
    cursor.execute(query)
    row = cursor.fetchone()

    while row:
        print(row)
        row = cursor.fetchone()  

def execute_scalar_function(cursor):
    cursor.execute(sql_task1)
    row = cursor.fetchone()

    while row:
        print(row)
        row = cursor.fetchone()  

def execute_table_fun(cursor):
    cursor.execute(sql_task2)
    rows = cursor.fetchall()

    for row in rows:
        print(row)          

def execute_procedure(cursor):
    cursor.execute(sql_task3)
    cursor.execute(f"select * from chats")
    row = cursor.fetchone()

    while row:
        print(row)
        row = cursor.fetchone()    

def execute_system_fun(cursor):
    cursor.execute("SELECT version();")
    result = cursor.fetchone()
    print(f"PostgreSQL version: {result[0]}")   

def create_table(cursor):
    query = """
    create table if not exists files(
        file_id SERIAL PRIMARY KEY,
        message_id INT REFERENCES messages(messageid),
        file_name VARCHAR(255) NOT NULL,
        file_type VARCHAR(50) NOT NULL,
        file_content BYTEA NOT NULL
    );
    """        
    cursor.execute(query)
    print("Таблица files создана успешно.")

def insert_file(cursor):
    try:
        query = f"insert into files (message_id, file_name, file_type, file_content)\
                values (3, 'file1.txt', 'text/plain', E'48656C6C6F2C20576F726C64'),\
                        (4, 'file2.jpg', 'image/jpeg', E'2F2F2F2F2F2F2F2F2F');"
        
        cursor.execute(query)
        print("Файл успешно добавлен в таблицу files.")

        cursor.execute(f"select * from files")
        row = cursor.fetchone()

        while row:
            print(row)
            row = cursor.fetchone()
    except:
        print("Таблица не существует!")       

def protection1(cursor):
    cursor.execute(protection)
    row = cursor.fetchone()

    while row:
        print(row)
        row = cursor.fetchone()

def execute(cursor, choice):
    if choice == 1:
        execute_scalar_query(cursor)
    elif choice == 2:
        execute_joins_query(cursor)
    elif choice == 3:
        execute_cte_query(cursor)
    elif choice == 4:
        execute_metadata_query(cursor)
    elif choice == 5:
        execute_scalar_function(cursor)
    elif choice == 6:
        execute_table_fun(cursor)
    elif choice == 7:
        execute_procedure(cursor)
    elif choice == 8:
        execute_system_fun(cursor)
    elif choice == 9:
        create_table(cursor)
    elif choice == 10:
        insert_file(cursor)
    elif choice == 11:
        protection1(cursor)

def menu():
    print("1) Получить количество записей в таблице Users")
    print("2) Получить информацию о пользователях, их сообщениях и группах, к которым они принадлежат")
    print("3) Найти пользователи, которые из Лондона")
    print("4) Получить список всех таблиц в базе данных")
    print("5) Вычислить количество непрочитанных сообщений для указанового пользователя")
    print("6) Вывести список всех сообщений для данного чата")
    print("7) Создать новый чат или добавить нового пользователя в существующий чат")
    print("8) Вызвать системную функцию, которая выводит информацию о версии PostgreSQL")
    print("9) Создать таблицу files")
    print("10) Заполнить таблицу files данными")
    print("11) protection")
    

    return int(input("Выберите действие: "))

def main():
    connect = connect_db('chatapp', 'lab01')

    if not connect:
        exit(-1)

    print('Database connected successfully')

    cursor = connect.cursor()
    choice = menu()    
    protection1(cursor)
    while (choice > 0 and choice < 12):
        try:
            execute(cursor, choice)
            print()
        except:
            connect.rollback()

        choice = menu()
    
    cursor.close()
    connect.close()

main()          