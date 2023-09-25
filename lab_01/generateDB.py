from faker import Faker
import requests

MAX_LEN = 1000

def getWords(https):
    response = requests.get(https)
    words = response.content.splitlines()

    return words

WORDS = getWords("https://www.mit.edu/~ecprice/wordlist.10000")

def generateUsers():
    faker = Faker()
    file = open('users.csv', 'w')

    for index in range(MAX_LEN):
        line = "{0};{1};{2};{3};{4};{5};{6}\n".format(
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
    file = open('chatMembers.csv', 'w')

    for index in range(MAX_LEN):
        line = "{0};{1};{2};{3}\n".format(
            faker.name(),
            faker.word(),
            faker.boolean(),
            faker.boolean())
        
        file.write(line)
    file.close()

def generateMessages():
    faker = Faker()
    file = open('messages.csv', 'w')
    counter = MAX_LEN

    for index in range(MAX_LEN):
        line = "{0};{1};{2};{3};{4}\n".format(
            index,
            counter,
            faker.random_int(0, 1000),
            faker.domain_word(),
            faker.date())
        
        counter -= 1
        file.write(line)
    file.close()

def generateChats():
    faker = Faker()
    file = open('chats.csv', 'w')

    for index in range(MAX_LEN):
        line = "{0};{1};{2}\n".format(
            faker.name(),
            faker.date(),
            faker.random_int(0, 1000))
        
        file.write(line)
    file.close()    

def main():
    generateUsers()
    generateMembers()
    generateMessages()
    generateChats()

main()