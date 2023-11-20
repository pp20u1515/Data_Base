from faker import Faker
import requests

MAX_LEN = 30

def getWords(https):
    response = requests.get(https)
    words = response.content.splitlines()

    return words

WORDS = getWords("https://www.mit.edu/~ecprice/wordlist.10000")

def generateUsers():
    faker = Faker()
    file = open('data/users.csv', 'w')

    for index in range(MAX_LEN + 1):
        line = "{0};{1};{2};{3};{4};{5};{6};{7}\n".format(
            index,
            faker.name(),
            faker.last_name(),
            faker.ascii_email(),
            faker.password(),
            faker.date(),
            faker.city(),
            faker.date())
        
        file.write(line)
    file.close()

def generateMembers():
    faker = Faker()
    file = open('data/chatMembers.csv', 'w')

    for index in range(MAX_LEN + 1):
        line = "{0};{1};{2};{3};{4}\n".format(
            index,
            index,
            index,
            faker.boolean(),
            faker.boolean())
        
        file.write(line)
    file.close()

def generateMessages():
    faker = Faker()
    file = open('data/messages.csv', 'w')

    for index in range(MAX_LEN + 1):
        line = "{0};{1};{2};{3};{4};{5};{6}\n".format(
            index,
            index,
            index,
            index,
            faker.domain_word(),
            faker.date(),
            faker.boolean())
        
        file.write(line)
    file.close()

def generateChats():
    faker = Faker()
    file = open('data/chats.csv', 'w')

    for index in range(MAX_LEN + 1):
        line = "{0};{1};{2};{3};{4}\n".format(
            index,
            faker.name(),
            faker.date(),
            faker.random_int(0, 1000),
            faker.random_int(0, 30))
        
        file.write(line)
    file.close()    

def main():
    generateUsers()
    generateMembers()
    generateMessages()
    generateChats()

main()