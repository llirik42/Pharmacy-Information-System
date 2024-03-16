import random
from typing import Union

from mysql.connector.abstracts import MySQLConnectionAbstract, MySQLCursorAbstract
from mysql.connector.pooling import PooledMySQLConnection

from settings import WAITING_SUPPLIES_ORDERS_COUNT, ORDERS_PRESCRIPTIONS_COUNT, DRUGS_COUNT


def insert_value(cursor: MySQLCursorAbstract, order_id: int, drug_id: int, amount: int) -> None:
    sql = "INSERT INTO db.orders_waiting_drug_supplies (order_id, drug_id, amount)\
    VALUES (%s, %s, %s)"
    val = (order_id, drug_id, amount)
    cursor.execute(sql, val)


def insert_values(db: Union[PooledMySQLConnection, MySQLConnectionAbstract], cursor: MySQLCursorAbstract) -> None:
    cursor.execute('DELETE FROM db.orders_waiting_drug_supplies')
    db.commit()

    for i in range(WAITING_SUPPLIES_ORDERS_COUNT):
        insert_value(
            cursor=cursor,
            order_id=random.randint(1, ORDERS_PRESCRIPTIONS_COUNT),
            drug_id=random.randint(1, DRUGS_COUNT),
            amount=random.randint(1, 10)
        )
    db.commit()