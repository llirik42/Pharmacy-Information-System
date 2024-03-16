import random
from datetime import date
from typing import Union, Optional

from mimesis import Datetime
from mysql.connector.abstracts import MySQLCursorAbstract, MySQLConnectionAbstract
from mysql.connector.pooling import PooledMySQLConnection

from settings import ORDERS_PRESCRIPTIONS_COUNT, CUSTOMERS_COUNT


def insert_order(cursor: MySQLCursorAbstract, order_id: int, prescription_id: int, registration_date: date, appointed_date: Optional[date], is_paid: bool, obtaining_date: Optional[date], customer_id: Optional[int]) -> None:
    sql = "INSERT INTO db.orders (id, prescription_id, registration_date, appointed_data, obtaining_date, is_paid, customer_id)\
    VALUES (%s, %s, %s, %s, %s, %s, %s)"
    val = (order_id, prescription_id, registration_date, appointed_date, obtaining_date, is_paid, customer_id)
    cursor.execute(sql, val)


def insert_orders(db: Union[PooledMySQLConnection, MySQLConnectionAbstract], cursor: MySQLCursorAbstract) -> None:
    cursor.execute('DELETE FROM db.orders')
    db.commit()

    d = Datetime()

    for i in range(ORDERS_PRESCRIPTIONS_COUNT):
        stage = random.randint(1, 3)
        registration_date = d.date(2024, 2024)
        customer_id = random.randint(1, CUSTOMERS_COUNT)
        appointed_date = None
        obtaining_date = None
        is_paid = False

        # Obtained
        if stage == 1:
            has_customer = bool(random.randint(1, 2) - 1)
            is_paid = True
            if has_customer:
                appointed_date = d.date(2024, 2024)
                while appointed_date < registration_date:
                    appointed_date = d.date(2024, 2024)

                obtaining_date = d.date(2024, 2024)
                while obtaining_date < appointed_date:
                    obtaining_date = d.date(2024, 2024)
                customer_id = random.randint(1, CUSTOMERS_COUNT)
            else:
                customer_id = None
                appointed_date = registration_date
                obtaining_date = registration_date

        # Has appointed date
        if stage == 2:
            customer_id = random.randint(1, CUSTOMERS_COUNT)
            appointed_date = d.date(2024, 2024)
            while appointed_date < registration_date:
                appointed_date = d.date(2024, 2024)
            is_paid = bool(random.randint(1, 2) - 1)
            obtaining_date = None
            
        # In production
        if stage == 3:
            customer_id = random.randint(1, CUSTOMERS_COUNT)
            appointed_date = None
            obtaining_date = None
            is_paid = False

        insert_order(
            cursor=cursor,
            order_id=i+1,
            prescription_id=i+1,
            registration_date=registration_date,
            appointed_date=appointed_date,
            obtaining_date=obtaining_date,
            is_paid=is_paid,
            customer_id=customer_id
        )

    db.commit()
