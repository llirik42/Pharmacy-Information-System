import random
from typing import Union, Optional
from datetime import date

from mimesis import Datetime
from mysql.connector.abstracts import MySQLCursorAbstract, MySQLConnectionAbstract
from mysql.connector.pooling import PooledMySQLConnection

from settings import ORDERS_PRESCRIPTIONS_COUNT, PRODUCTION_COUNT, TECHNOLOGIES_COUNT


def insert_production(cursor: MySQLCursorAbstract, order_id: int, technology_id: int, amount: int, start_date: date, end_date: Optional[date]) -> None:
    sql = "INSERT INTO db.production (order_id, technology_id, amount, start_date, end_date)\
    VALUES (%s, %s, %s, %s, %s)"
    val = (order_id, technology_id, amount, start_date, end_date)
    cursor.execute(sql, val)


def insert_production_all(db: Union[PooledMySQLConnection, MySQLConnectionAbstract], cursor: MySQLCursorAbstract) -> None:
    cursor.execute('DELETE FROM db.production')
    db.commit()

    d = Datetime()

    for i in range(PRODUCTION_COUNT):
        end = bool(random.randint(1, 2) - 1)
        start_date = d.date(start=2024)

        if end:
            end_date = d.date(start=2024)
            while end_date < start_date:
                end_date = d.date(start=2024)
        else:
            end_date = None

        insert_production(
            cursor=cursor,
            order_id=random.randint(1, ORDERS_PRESCRIPTIONS_COUNT),
            technology_id=random.randint(1, TECHNOLOGIES_COUNT),
            amount=random.randint(1, 10),
            start_date=start_date,
            end_date=end_date
        )

    db.commit()
