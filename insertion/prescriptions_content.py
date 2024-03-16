import random
from typing import Union

from mimesis import Text, Locale, Datetime
from mysql.connector.abstracts import MySQLConnectionAbstract, MySQLCursorAbstract
from mysql.connector.pooling import PooledMySQLConnection

from settings import PATIENTS_ORDERS, DOCTORS_COUNT, ORDERS_PRESCRIPTIONS_COUNT, \
    PRESCRIPTIONS_CONTENT_LENGTH, DRUGS_COUNT


def insert_prescription_content(cursor: MySQLCursorAbstract, prescription_id: int, drug_id: int, amount: int, administration_route_id: int) -> None:
    sql = "INSERT INTO db.prescriptions_content (prescription_id, drug_id, amount, administration_route_id)\
    VALUES (%s, %s, %s, %s)"
    val = (prescription_id, drug_id, amount, administration_route_id)
    cursor.execute(sql, val)


def insert_prescriptions_contents(db: Union[PooledMySQLConnection, MySQLConnectionAbstract], cursor: MySQLCursorAbstract) -> None:
    cursor.execute('DELETE FROM db.prescriptions_content')
    db.commit()

    t = Text(Locale.RU)
    dd = Datetime()

    necc = [i + 1 for i in range(0, ORDERS_PRESCRIPTIONS_COUNT)]

    for i in range(PRESCRIPTIONS_CONTENT_LENGTH):
        if len(necc) == 0:
            prescription_id = random.randint(1, ORDERS_PRESCRIPTIONS_COUNT)
        else:
            rand_index = random.randint(0, len(necc) - 1)
            prescription_id = necc[rand_index]
            necc.pop(rand_index)

        insert_prescription_content(
            cursor=cursor,
            prescription_id=prescription_id,
            drug_id=random.randint(1, DRUGS_COUNT),
            amount=random.randint(1, 3),
            administration_route_id=random.randint(1, 2)
        )

    db.commit()
