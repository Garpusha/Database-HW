import psycopg2
from psycopg2.extensions import AsIs
import configparser
from random import randint

class UserRecords:

    def __init__(self, host_, port_, dbname_, user_, password_):
        self.connection = psycopg2.connect(host=host_, port=port_, dbname=dbname_, user=user_, password=password_)

    def create_structure(self):
        with self.connection.cursor() as my_cur:
            my_cur.execute('''
            CREATE TABLE IF NOT EXISTS users ( 
            user_id SERIAL PRIMARY KEY,
            name VARCHAR(20) NOT NULL,
            surname VARCHAR(20)
            );''')
            my_cur.execute('''
            CREATE TABLE IF NOT EXISTS phones (
            phone_id SERIAL PRIMARY KEY,
            phone_no VARCHAR(20),
            user_id int,
            FOREIGN KEY (user_id) REFERENCES users (user_id)
            );''')
            my_cur.execute('''
            CREATE TABLE IF NOT EXISTS emails (
            email_id SERIAL PRIMARY KEY,
            email VARCHAR(50),
            user_id int,
            FOREIGN KEY (user_id) REFERENCES users (user_id)
            );''')
            self.connection.commit()

    def load_data(self, table_name, file_name):
        with self.connection.cursor() as my_cur:
            my_cur.execute("""
            COPY %s FROM %s DELIMITER ';' CSV HEADER;
            """, (AsIs(table_name), file_name))
            self.connection.commit()

    def create(self, user_details):
        with self.connection.cursor() as my_cur:
            my_cur.execute("SELECT max(user_id) FROM users;")
            user_id = my_cur.fetchone()
            user_id = user_id[0]
            user_id += 1
            my_cur.execute("SELECT max(email_id) FROM emails;")
            email_id = my_cur.fetchone()
            email_id = email_id[0]
            email_id += 1
            my_cur.execute("SELECT max(phone_id) FROM phones;")
            phone_id = my_cur.fetchone()
            phone_id = phone_id[0]
            phone_id += 1
            my_cur.execute("""
            INSERT INTO %s (user_id, name, surname) VALUES (%s, %s, %s);
            """, (AsIs('users'), user_id, user_details[0], user_details[1]))
            self.connection.commit()
            my_cur.execute("""
            INSERT INTO %s (email_id, email, user_id) VALUES (%s, %s, %s);
            """, (AsIs('emails'), email_id, user_details[2], user_id))
            self.connection.commit()
            for phone_no in user_details[3]:
                my_cur.execute("""
                INSERT INTO %s (phone_id, phone_no, user_id) VALUES (%s, %s, %s);
                """, (AsIs('phones'), phone_id, phone_no, user_id))
                phone_id += 1
            self.connection.commit()
            print(f'New record added:\nID: {user_id}, Name: {user_details[0]} {user_details[1]}')
            print(f'E-mail: {user_details[2]} Phone(s): {user_details[3]}')

    def get_list(self):
        with self.connection.cursor() as my_cur:
            my_cur.execute("""
            SELECT user_id, name, surname FROM users;
            """)
            records_ = my_cur.fetchall()
            for record_ in records_:
                print(f'{record_[0]}. {record_[1]} {record_[2]}')
                # user_id = str(record_[0])
                my_cur.execute("""
                SELECT email FROM emails
                WHERE user_id = %s;""", (record_[0],))
                emails_ = my_cur.fetchall()
                print('Emails:', end=' ')
                [print(email_[0], end=' ') for email_ in emails_]
                my_cur.execute("""
                SELECT phone_no FROM phones
                WHERE user_id = %s;""", (record_[0],))
                phones_ = my_cur.fetchall()
                print('\nPhones:', end=' ')
                [print(phone_[0], end=' ') for phone_ in phones_]
                print('\n')

    def add_phone(self):
        user_id = input('Enter UserID to add phone number: ')
        if not user_id.isdecimal():
            print('Wrong ID, only decimal numbers allowed.')
            return
        user_id = int(user_id)
        with self.connection.cursor() as my_cur:
            my_cur.execute("""
            SELECT user_id FROM users;
            """)
            records_ = my_cur.fetchall()
            records_ = [(record_[0]) for record_ in records_]
            if not user_id in records_:
                print(f'UserID {user_id} not found.')
                return
            phone_ = randint(1000000, 9999999)
            my_cur.execute("SELECT max(phone_id) FROM phones;")
            phone_id = my_cur.fetchone()
            phone_id = phone_id[0]
            phone_id += 1
            my_cur.execute("""INSERT INTO phones (phone_id, phone_no, user_id)
            VALUES (%s, %s, %s);""", (phone_id, phone_, user_id))
            self.connection.commit()
            print(f'Phone number {phone_} was added to UserID {user_id}')

def read_config(path, section, parameter):
     config = configparser.ConfigParser()
     config.read(path)
     c_value = config.get(section, parameter)
     return c_value



def get_new_identity():
    phone_ = []
    names = ['John', 'Peter', 'Tanya', 'Elena', 'Bill', 'Phil', 'Andrew', 'Alex', 'Joanna', 'Ivanna', 'Iren', \
            'Sam', 'Bruce', 'Kylie', 'Daniel', 'Linda', 'Mary', 'Chris', 'Christina', 'Penny']
    name_ = names[randint(0, len(names))]
    surnames = ['Johnson', 'Curtis', 'Willis', 'Smith', 'Ripley', 'Morgan', 'Jefferson', 'McCallan', 'Andersson',\
               'Peterson', 'Jackson', 'Jones', 'Sanders', 'Nixon', 'Callahan', 'Richards', 'Newman', 'Hatfield',\
               'Newman', 'Burton']
    surname_ = surnames[randint(0, len(surnames))]

    phone_ = [randint(1000000, 9999999) for index in range(0, randint(0, 2))]
    mail_ = f'{name_}.{surname_}@fakeidentity.com'
    return [name_, surname_, mail_, phone_]

if __name__ != '__main__':
    exit()
host = read_config('config.ini', 'Main', 'IP')
port = read_config('config.ini', 'Main', 'Port')
db_name = read_config('config.ini', 'Credentials', 'DBName')
user_name = read_config('config.ini', 'Credentials', 'UserName')
password = read_config('config.ini', 'Credentials', 'Password')
path_to_csv = read_config('config.ini', 'Main', 'DataPath')

my_record = UserRecords(host, port, db_name, user_name, password)
my_record.create_structure()
# my_record.load_data('users', f'{path_to_csv}users.csv')
# my_record.load_data('emails', f'{path_to_csv}emails.csv')
# my_record.load_data('phones', f'{path_to_csv}phones.csv')

while True:
    print('-' * 20)
    print('1. Add record\n2. Add phone number\n3. Change record')
    print('4. Delete phone\n5. Delete record\n6. Find record\n7. List records\n0. Exit')
    print('-' * 20)
    choice = input('Enter option: ')
    if choice == '0':
        print('Goodbye!')
        exit()
    elif choice == '1':
        my_record.create(get_new_identity())
    elif choice == '2':
        my_record.add_phone()
    elif choice == '7':
        my_record.get_list()




