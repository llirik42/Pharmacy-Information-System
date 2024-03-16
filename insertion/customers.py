from typing import Union

from mimesis import Locale, Gender, Person, Address
from mimesis.builtins import RussiaSpecProvider
from mysql.connector.abstracts import MySQLCursorAbstract, MySQLConnectionAbstract
from mysql.connector.pooling import PooledMySQLConnection

from settings import CUSTOMERS_COUNT


def insert_customer(cursor: MySQLCursorAbstract, customer_id: int, full_name: str, phone_number: str, addres: str) -> None:
    sql = "INSERT INTO db.customers (id, full_name, phone_number, address)\
    VALUES (%s, %s, %s, %s)"
    val = (customer_id, full_name, phone_number, addres)

    cursor.execute(sql, val)


def insert_customers(db: Union[PooledMySQLConnection, MySQLConnectionAbstract], cursor: MySQLCursorAbstract) -> None:
    cursor.execute('DELETE FROM db.customers')
    db.commit()

    p = Person(locale=Locale.RU)
    r = RussiaSpecProvider()
    a = Address(locale=Locale.RU)
    city = a.city()

    for i in range(CUSTOMERS_COUNT):
        g = Gender.FEMALE if p.gender() == 'Жен.' else Gender.MALE
        full_name = f'{p.last_name(gender=g)} {p.name(gender=g)} {r.patronymic(gender=g)}'
        address: str = f'{city}, ул. {a.street_name()}, д. {a.street_number()}'
        insert_customer(cursor, i + 1, full_name, p.phone_number(), address)

    db.commit()
