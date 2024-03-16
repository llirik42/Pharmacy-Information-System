from datetime import date
from typing import Union

from mimesis import Locale, Gender, Person, Datetime
from mimesis.builtins import RussiaSpecProvider
from mysql.connector.abstracts import MySQLCursorAbstract, MySQLConnectionAbstract
from mysql.connector.pooling import PooledMySQLConnection

from settings import PATIENTS_ORDERS


def insert_patient(cursor: MySQLCursorAbstract, patient_id: int, full_name: str, birthday: date) -> None:
    sql = "INSERT INTO db.patients (id, full_name, birthday)\
    VALUES (%s, %s, %s)"
    val = (patient_id, full_name, birthday)
    cursor.execute(sql, val)


def insert_patients(db: Union[PooledMySQLConnection, MySQLConnectionAbstract], cursor: MySQLCursorAbstract) -> None:
    cursor.execute('DELETE FROM db.patients')
    db.commit()

    p = Person(locale=Locale.RU)
    r = RussiaSpecProvider()
    d = Datetime()

    for i in range(PATIENTS_ORDERS):
        g = Gender.FEMALE if p.gender() == 'Жен.' else Gender.MALE
        full_name = f'{p.last_name(gender=g)} {p.name(gender=g)} {r.patronymic(gender=g)}'
        birthday = d.date(start=1950, end=2000)
        insert_patient(cursor, i + 1, full_name, birthday)
    db.commit()
