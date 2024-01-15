from task_01 import Users
import json
import psycopg2 as pg_lib
from datetime import date

class DateEncoder(json.JSONEncoder):
    def default(self, obj):
        if isinstance(obj, date):
            return obj.isoformat()  # Преобразование date в строку
        return super().default(obj)

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

def read_table_json(cursor):
    cursor.execute("select * from users")
    column_names = [desc[0] for desc in cursor.description]
    rows = cursor.fetchall()

    data = []
    for row in rows:
        row_dict = dict(zip(column_names, row))
        data.append(row_dict)
        
    return data

def create_json_file(data, file_path):
    with open(file_path, "w") as json_file:
        json.dump(data, json_file, indent=4, cls=DateEncoder)
        print(f"JSON создан в {file_path}")

def read_json_file(file_path):
    with open(file_path, 'r') as json_file:
        data = json.load(json_file)

    return data

def output_json_file(data):
    for elem in data:
        print(elem)

def update_json_file(file_path, update_data):
    with open(file_path, "r") as json_file:
        existing_data = json.load(json_file)

    # Найдем индекс элемента, который вы хотите обновить
    index_to_update = next((i for i, user in enumerate(existing_data) if user['userid'] == update_data['userid']), None)

    if index_to_update is not None:
        # Обновим элемент в списке
        existing_data[index_to_update].update(update_data)
        
        # Запись обновленных данных обратно в файл
        with open(file_path, 'w') as json_file:
            json.dump(existing_data, json_file, indent=4)

        print(f"JSON документ в {file_path} обновлен успешно.")
    else:
        print(f"Пользователь с userid={update_data['userid']} не найден в JSON документе.")
  
def add_to_json_file(file_path, new_data):
    with open(file_path, "r") as json_file:
        existing_data = json.load(json_file)

    existing_data.append(new_data)

    with open(file_path, 'w') as json_file:
        json.dump(existing_data, json_file, indent=4)

    print(f"Новые данные успешно добавлены в JSON документ в {file_path}.")


def task_02():
    connect = connect_db('chatapp', '2v7z998d')

    if not connect:
        exit(-1)

    print('Database connected successfully')

    cursor = connect.cursor()
    
    print()
    print("Чтение из json файла")
    users_data = read_table_json(cursor)

    if (users_data):
        create_json_file(users_data, "data/output.json")
        users_data = read_json_file("data/output.json")
        output_json_file(users_data)

    print()
    print('Обновить JSON файл')
    update_data = {
        "userid": 29,
        "firstname": "William Rivera",
        "lastname": "Cain",
        "email": "rhonda41@hotmail.com",
        "userpassword": "@dE9Gpu7E5",
        "dateofbirthday": "1996-02-03",
        "usercity": "London",
        "userdateregistration": "1978-09-29"
    }
    update_json_file("data/output.json", update_data)

    print()
    print("Добавить пользователь в json файле")
    new_data = {
        "userid": 31,
        "firstname": "William Rivera",
        "lastname": "Cain",
        "email": "rhonda41@hotmail.com",
        "userpassword": "@dE9Gpu7E5",
        "dateofbirthday": "1996-02-03",
        "usercity": "London",
        "userdateregistration": "1978-09-29"
    }
    add_to_json_file("data/output.json", new_data)

    cursor.close()
    connect.close()