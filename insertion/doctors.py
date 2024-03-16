from typing import Union

from mimesis import Gender, Locale, Person
from mimesis.builtins import RussiaSpecProvider
from mysql.connector.abstracts import MySQLCursorAbstract, MySQLConnectionAbstract
from mysql.connector.pooling import PooledMySQLConnection

from settings import DOCTORS_COUNT


def insert_doctor(cursor: MySQLCursorAbstract, doctor_id: int, doctor_name: str) -> None:
    sql = "INSERT INTO db.doctors (id, full_name)\
    VALUES (%s, %s)"
    val = (doctor_id, doctor_name)

    cursor.execute(sql, val)


def insert_doctors(db: Union[PooledMySQLConnection, MySQLConnectionAbstract], cursor: MySQLCursorAbstract) -> None:
    cursor.execute('DELETE FROM db.doctors')
    db.commit()

    p = Person(locale=Locale.RU)
    r = RussiaSpecProvider()

    for i in range(DOCTORS_COUNT):
        g = Gender.FEMALE if p.gender() == 'Жен.' else Gender.MALE
        insert_doctor(cursor, i + 1, f'{p.last_name(gender=g)} {p.name(gender=g)} {r.patronymic(gender=g)}')

    db.commit()
