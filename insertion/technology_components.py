import random
from typing import Union

from mysql.connector.abstracts import MySQLConnectionAbstract, MySQLCursorAbstract
from mysql.connector.pooling import PooledMySQLConnection

from settings import TECHNOLOGIES_COUNT, DRUGS_COUNT


def insert_technology_components(cursor: MySQLCursorAbstract, technology_id: int, component_id: int, component_amount: int) -> None:
    sql = "INSERT INTO db.technology_components (technology_id, component_id, component_amount)\
    VALUES (%s, %s, %s)"
    val = (technology_id, component_id, component_amount)
    cursor.execute(sql, val)


def insert_technologies_components(db: Union[PooledMySQLConnection, MySQLConnectionAbstract], cursor: MySQLCursorAbstract) -> None:
    cursor.execute('DELETE FROM db.technology_components')
    db.commit()

    for i in range(TECHNOLOGIES_COUNT):
        components_count = random.randint(2, 5)
        technology_id: int = i + 1

        sql = "SELECT id, drug_id FROM db.technologies WHERE id = %s"
        val = (technology_id,)
        cursor.execute(sql, val)
        target_drug_id: int = cursor.fetchall()[0][1]

        taken = []
        for j in range(components_count):
            drug_id = random.randint(1, DRUGS_COUNT)
            while drug_id == target_drug_id or drug_id in taken:
                drug_id = random.randint(1, DRUGS_COUNT)

            taken.append(drug_id)

            insert_technology_components(
                cursor=cursor,
                technology_id=technology_id,
                component_id=drug_id,
                component_amount=random.randint(1, 5),
            )

    db.commit()