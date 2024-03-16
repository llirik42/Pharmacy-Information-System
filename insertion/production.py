import random
from typing import Union

from mysql.connector.abstracts import MySQLCursorAbstract, MySQLConnectionAbstract
from mysql.connector.pooling import PooledMySQLConnection

from settings import ORDERS_PRESCRIPTIONS_COUNT, PRODUCTION_COUNT, TECHNOLOGIES_COUNT


def insert_production(cursor: MySQLCursorAbstract, order_id: int, technology_id: int, amount: int) -> None:
    sql = "INSERT INTO db.production (order_id, technology_id, amount)\
    VALUES (%s, %s, %s)"
    val = (order_id, technology_id, amount)
    cursor.execute(sql, val)


def insert_production_all(db: Union[PooledMySQLConnection, MySQLConnectionAbstract], cursor: MySQLCursorAbstract) -> None:
    cursor.execute('DELETE FROM db.production')
    db.commit()

    for i in range(PRODUCTION_COUNT):
        insert_production(
            cursor=cursor,
            order_id=random.randint(1, ORDERS_PRESCRIPTIONS_COUNT),
            technology_id=random.randint(1, TECHNOLOGIES_COUNT),
            amount=random.randint(1, 10),
        )

    db.commit()
