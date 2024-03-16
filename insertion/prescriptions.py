import random
from typing import Union

from datetime import date

from mimesis import Text, Locale, Datetime
from mysql.connector.abstracts import MySQLConnectionAbstract, MySQLCursorAbstract
from mysql.connector.pooling import PooledMySQLConnection

from settings import PATIENTS_ORDERS, DOCTORS_COUNT, ORDERS_PRESCRIPTIONS_COUNT


def insert_prescription(cursor: MySQLCursorAbstract, prescription_id: int, diagnosis: str, patient_id: int, doctor_id: int, d: date) -> None:
    sql = "INSERT INTO db.prescriptions (id, diagnosis, patient_id, doctor_id, date)\
    VALUES (%s, %s, %s, %s, %s)"
    val = (prescription_id, diagnosis, patient_id, doctor_id, d)
    cursor.execute(sql, val)


def insert_prescriptions(db: Union[PooledMySQLConnection, MySQLConnectionAbstract], cursor: MySQLCursorAbstract) -> None:
    cursor.execute('DELETE FROM db.prescriptions')
    db.commit()

    t = Text(Locale.RU)
    dd = Datetime()

    necc = [i + 1 for i in range(PATIENTS_ORDERS)]

    for i in range(ORDERS_PRESCRIPTIONS_COUNT):
        if len(necc) == 0:
            patient_id = random.randint(1, PATIENTS_ORDERS)
        else:
            rand_index = random.randint(0, len(necc) - 1)
            patient_id = necc[rand_index]
            necc.pop(rand_index)

        insert_prescription(
            cursor=cursor,
            prescription_id=i + 1,
            diagnosis=t.sentence(),
            patient_id=patient_id,
            doctor_id=random.randint(1, DOCTORS_COUNT),
            d=dd.date(start=2023)
        )

    db.commit()
