from py_linq import *
from datetime import datetime, timedelta

class Users:
    user_id = int()
    firstname = str()
    lastname = str()
    email = str()
    user_password = str()
    date_of_birthday = str()
    user_city = str()
    user_date_registration = str()

    def __init__(self, user_id, firstname, lastname, email, user_password,
                 date_of_birthday, user_city, user_date_registration):
        self.user_id = user_id
        self.firstname = firstname
        self.lastname = lastname
        self.email = email
        self.user_password = user_password
        self.date_of_birthday = date_of_birthday
        self.user_city = user_city
        self.user_date_registration = user_date_registration

    def get(self):
        return {'user_id': self.user_id, 'firstname': self.firstname, 'lastname': self.lastname,
                'email': self.email, 'user_password': self.user_password,
                'date_of_birthday': self.date_of_birthday, 'user_city': self.user_city,
                'user_date_registration': self.user_date_registration}    

def create_users(file):
    file = open(file, 'r')
    users = list()

    for line in file:
        arr = line.split(';')
        users.append(Users(*arr).get())

    return users

def query_01(users):
    # Определим дату 30 лет назад от текущей даты
    thirty_years = datetime.now() - timedelta(days=30 * 365)
    result = users.where(lambda x: datetime.strptime(x['date_of_birthday'], '%Y-%m-%d') <= thirty_years).order_by(lambda x: x['firstname']).select(lambda x: {x['firstname'], x['date_of_birthday']})

    return result

def query_02(users):
    # Определим дату 30 лет назад от текущей даты
    thirty_years = datetime.now() - timedelta(days=30 * 365)
    result = users.count(lambda x: datetime.strptime(x['date_of_birthday'], '%Y-%m-%d') <= thirty_years)

    return result

def calculate_age(birthdate):
    birthdate = datetime.strptime(birthdate, "%Y-%m-%d")
    today = datetime.now()
    age = today.year - birthdate.year - ((today.month, today.day) < (birthdate.month, birthdate.day))
    
    return age

def query_03(users):
    # Измененная функция query_01 для нахождения минимального и максимального возраста
    ages = [calculate_age(user['date_of_birthday']) for user in users]
    min_age = min(ages)
    max_age = max(ages)
    
    return min_age, max_age

def query_04(users):
    result = users.where(lambda x: x['user_city'].startswith('M')).select(lambda x: x['firstname'])
    
    return result

def query_05(users):
    grouped_users = {}
    for user in users:
        city = user['user_city']
        if city not in grouped_users:
            grouped_users[city] = 1
        else:
            grouped_users[city] += 1

    result_sorted = sorted(grouped_users.items(), key=lambda x: x[0])
    return result_sorted


def task_01():
    users = Enumerable(create_users('data/users.csv'))  
    
    print("Пользователи старше 30 лет")
    for elem in query_01(users):
        print(elem) 

    print()
    print(f"Количество пользователей старше 30 лет: {str(query_02(users))}")

    print()
    min_age, max_age = query_03(users)
    print(f"Минимальный возраст: {min_age} лет")
    print(f"Максимальный возраст: {max_age} лет")

    print()
    print('Выбрать всех пользователей, чей город начинается на "M"')
    for elem in query_04(users):
        print(elem)

    print()
    print('Сгруппировать пользователей по городу и вывести количество пользователей в каждом городе.')
    for elem in query_05(users):
        print(elem)

        