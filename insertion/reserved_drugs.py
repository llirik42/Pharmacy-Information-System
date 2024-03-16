import random
from typing import Union

from mysql.connector.abstracts import MySQLConnectionAbstract, MySQLCursorAbstract
from mysql.connector.pooling import PooledMySQLConnection

from settings import WAITING_SUPPLIES_ORDERS_COUNT, ORDERS_PRESCRIPTIONS_COUNT, STORAGE_ITEMS_COUNT


def insert_value(cursor: MySQLCursorAbstract, order_id: int, storage_item_id: int, amount: int) -> None:
    sql = "INSERT INTO db.reserved_drugs (order_id, storage_item_id, drug_amount)\
    VALUES (%s, %s, %s)"
    val = (order_id, storage_item_id, amount)
    cursor.execute(sql, val)


def insert_reserved_order_drugs(db: Union[PooledMySQLConnection, MySQLConnectionAbstract], cursor: MySQLCursorAbstract) -> None:
    cursor.execute('DELETE FROM db.reserved_drugs')
    db.commit()

    for i in range(WAITING_SUPPLIES_ORDERS_COUNT):
        insert_value(
            cursor=cursor,
            order_id=random.randint(1, ORDERS_PRESCRIPTIONS_COUNT),
            storage_item_id=random.randint(1, STORAGE_ITEMS_COUNT),
            amount=random.randint(1, 10)
        )
    db.commit()
