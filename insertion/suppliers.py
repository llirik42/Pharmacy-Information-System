from typing import Union

from mimesis import Locale, Person, Finance
from mysql.connector.abstracts import MySQLCursorAbstract, MySQLConnectionAbstract
from mysql.connector.pooling import PooledMySQLConnection

from settings import SUPPLIERS_COUNT


def insert_supplier(cursor: MySQLCursorAbstract, supplier_id: int, name: str, phone_number: str) -> None:
    sql = "INSERT INTO db.suppliers (id, name, phone_number)\
    VALUES (%s, %s, %s)"
    val = (supplier_id, name, phone_number)
    cursor.execute(sql, val)


def insert_suppliers(db: Union[PooledMySQLConnection, MySQLConnectionAbstract], cursor: MySQLCursorAbstract) -> None:
    cursor.execute('DELETE FROM db.suppliers')
    db.commit()

    f = Finance(Locale.RU)
    p = Person(locale=Locale.RU)

    for i in range(SUPPLIERS_COUNT):
        insert_supplier(
            cursor=cursor,
            supplier_id=i+1,
            name=f.company(),
            phone_number=p.phone_number()
        )

    db.commit()
