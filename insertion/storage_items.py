import random
from typing import Union

from mimesis.providers import date, Datetime
from mysql.connector.abstracts import MySQLCursorAbstract, MySQLConnectionAbstract
from mysql.connector.pooling import PooledMySQLConnection

from settings import STORAGE_ITEMS_COUNT, DRUGS_COUNT


def insert_storage_item(cursor: MySQLCursorAbstract, item_id: int, drug_id: int, current_amount: int, original_amount: int, receipt_date: date) -> None:
    sql = "INSERT INTO db.storage_items (id, drug_id, current_amount, original_amount, receipt_date)\
    VALUES (%s, %s, %s, %s, %s)"
    val = (item_id, drug_id, current_amount, original_amount, receipt_date)
    cursor.execute(sql, val)


def insert_storage_items(db: Union[PooledMySQLConnection, MySQLConnectionAbstract], cursor: MySQLCursorAbstract) -> None:
    cursor.execute('DELETE FROM db.storage_items')
    db.commit()

    d = Datetime()

    for i in range(STORAGE_ITEMS_COUNT):
        max_amount = random.randint(10, 100) // 5 * 5

        insert_storage_item(
            cursor=cursor,
            item_id=i + 1,
            drug_id=random.randint(1, DRUGS_COUNT),
            current_amount=random.randint(0, max_amount),
            original_amount=max_amount,
            receipt_date=d.date(start=2024, end=2024)
        )

    db.commit()
