import random
from datetime import date
from typing import Union

from mimesis import Datetime
from mysql.connector.abstracts import MySQLCursorAbstract, MySQLConnectionAbstract
from mysql.connector.pooling import PooledMySQLConnection

from settings import SUPPLIERS_COUNT, SUPPLIES_COUNT, DRUGS_COUNT


def insert_supply(cursor: MySQLCursorAbstract, supply_id: int, drug_id: int, drug_amount: int, cost: int, delivery_date: date, supplier_id: int) -> None:
    sql = "INSERT INTO db.supplies (id, drug_id, drug_amount, cost, delivery_date, supplier_id)\
    VALUES (%s, %s, %s, %s, %s, %s)"
    val = (supply_id, drug_id, drug_amount, cost, delivery_date, supplier_id)
    cursor.execute(sql, val)


def insert_supplies(db: Union[PooledMySQLConnection, MySQLConnectionAbstract], cursor: MySQLCursorAbstract) -> None:
    cursor.execute('DELETE FROM db.supplies')
    db.commit()

    d = Datetime()

    for i in range(SUPPLIES_COUNT):
        insert_supply(
            cursor=cursor,
            supply_id=i + 1,
            drug_id=random.randint(1, DRUGS_COUNT),
            drug_amount=random.randint(10, 100) // 5 * 5,
            cost=random.randint(2, 500) * 100 - 1,
            delivery_date=d.date(start=2024, end=2025),
            supplier_id=random.randint(1, SUPPLIERS_COUNT)
        )

    db.commit()
