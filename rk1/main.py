from faker import Faker
import requests
import datetime
import random

MAX_LEN = 30

def getWords(https):
    response = requests.get(https)
    words = response.content.splitlines()

    return words

WORDS = getWords("https://www.mit.edu/~ecprice/wordlist.10000")

def generateWorks():
    faker = Faker()
    file = open('typesWork.csv', 'w')

    for index in range(MAX_LEN + 1):
        line = "{0};{1};{2};{3}\n".format(
            index,
            faker.word(),
            faker.word(),
            faker.word())
        
        file.write(line)
    file.close()

def generateSender():
    faker = Faker()
    file = open('sender.csv', 'w')

    for index in range(MAX_LEN + 1):
        line = "{0};{1};{2};{3};{4}\n".format(
            index,
            faker.name(),
            faker.date(),
            random.randint(1, 20),
            random.randint(1, 1000),)
        
        file.write(line)
    file.close()    

def generateOrder():
    faker = Faker()
    file = open('order.csv', 'w')

    for index in range(MAX_LEN + 1):
        line = "{0};{1};{2};{3};{4}\n".format(
            index,
            faker.name(),
            faker.date(),
            random.randint(1, 20),
            random.randint(1000, 2000))
        
        file.write(line)
    file.close()           

def main():
   generateWorks()
   generateOrder()
   generateSender()

main()
