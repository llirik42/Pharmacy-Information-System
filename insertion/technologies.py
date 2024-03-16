import random
from typing import Union

from mimesis import Text, Locale
from mysql.connector.abstracts import MySQLCursorAbstract, MySQLConnectionAbstract
from mysql.connector.pooling import PooledMySQLConnection

from settings import TECHNOLOGIES_COUNT, DRUGS_COUNT


def insert_technology(cursor: MySQLCursorAbstract, technology_id: int, drug_id: int, cooking_time: int, amount: int, description: str) -> None:
    sql = "INSERT INTO db.technologies (id, drug_id, cooking_time, amount, description)\
    VALUES (%s, %s, %s, %s, %s)"
    val = (technology_id, drug_id, cooking_time, amount, description)
    cursor.execute(sql, val)


def insert_technologies(db: Union[PooledMySQLConnection, MySQLConnectionAbstract], cursor: MySQLCursorAbstract) -> None:
    cursor.execute('DELETE FROM db.technologies')
    db.commit()

    t = Text(Locale.RU)

    for i in range(TECHNOLOGIES_COUNT):
        drug_id = random.randint(1, DRUGS_COUNT)
        sql = "SELECT * FROM db.drugs WHERE id = %s"
        val = (drug_id,)
        cursor.execute(sql, val)
        drug_type_id = cursor.fetchall()[0][5]

        while drug_type_id == 1:
            drug_id = random.randint(1, DRUGS_COUNT)
            val = (drug_id,)
            cursor.execute(sql, val)
            drug_type_id = cursor.fetchall()[0][5]

        insert_technology(
            cursor=cursor,
            technology_id=i+1,
            drug_id=drug_id,
            cooking_time=random.randint(15, 14440) // 15 * 15,
            amount=random.randint(1, 10),
            description=t.sentence()
        )

    db.commit()
