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

def generateAnimal():
    faker = Faker()
    file = open('animal.csv', 'w')

    for index in range(MAX_LEN + 1):
        line = "{0};{1};{2};{3}\n".format(
            index,
            faker.name(),
            faker.word(),
            faker.name())
        
        file.write(line)
    file.close()

def generateSickness():
    faker = Faker()
    file = open('sickness.csv', 'w')

    for index in range(MAX_LEN + 1):
        line = "{0};{1};{2};{3}\n".format(
            index,
            faker.name(),
            faker.word(),
            faker.word())
        
        file.write(line)
    file.close()    

def generateOwners():
    faker = Faker()
    file = open('owners.csv', 'w')

    for index in range(MAX_LEN + 1):
        line = "{0};{1};{2};{3}\n".format(
            index,
            faker.name(),
            faker.address(),
            faker.phone())
        
        file.write(line)
    file.close()           

def main():
   generateAnimal()
   generateSickness()
   generateOwners()

main()
