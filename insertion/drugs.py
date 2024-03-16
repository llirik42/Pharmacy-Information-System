import random
from typing import Union

from mimesis import Food, Locale

from mysql.connector.abstracts import MySQLCursorAbstract, MySQLConnectionAbstract
from mysql.connector.pooling import PooledMySQLConnection

from settings import DRUGS_COUNT


def insert_drug(cursor: MySQLCursorAbstract, drug_id: int, name: str, cost: int, shelf_life: int, critical_amount: int, type_id: int, description: str) -> None:
    sql = "INSERT INTO db.drugs (id, name, cost, shelf_life, critical_amount, type_id, description)\
    VALUES (%s, %s, %s, %s, %s, %s, %s)"
    val = (drug_id, name, cost, shelf_life, critical_amount, type_id, description)
    cursor.execute(sql, val)


def insert_tincture(cursor: MySQLCursorAbstract, drug_id: int, material: str) -> None:
    sql = "INSERT INTO db.tinctures (drug_id, material) VALUES (%s, %s)"
    val = (drug_id, material)
    cursor.execute(sql, val)


def insert_solution(cursor: MySQLCursorAbstract, drug_id: int, dosage: int) -> None:
    sql = "INSERT INTO db.solutions (drug_id, dosage) VALUES (%s, %s)"
    val = (drug_id, dosage)
    cursor.execute(sql, val)


def insert_salve(cursor: MySQLCursorAbstract, drug_id: int, active_substance: str) -> None:
    sql = "INSERT INTO db.salves (drug_id, active_substance) VALUES (%s, %s)"
    val = (drug_id, active_substance)
    cursor.execute(sql, val)


def insert_powder(cursor: MySQLCursorAbstract, drug_id: int, is_composite: bool) -> None:
    sql = "INSERT INTO db.powders (drug_id, is_composite) VALUES (%s, %s)"
    val = (drug_id, is_composite)
    cursor.execute(sql, val)


def insert_pills(cursor: MySQLCursorAbstract, drug_id: int, weight_of_pill: int, total_weight) -> None:
    sql = "INSERT INTO db.pills (drug_id, weight_of_pill, total_weight) VALUES (%s, %s, %s)"
    val = (drug_id, weight_of_pill, total_weight)
    cursor.execute(sql, val)


def insert_mixture(cursor: MySQLCursorAbstract, drug_id: int, solvent: str, mixture_type_id: int) -> None:
    sql = "INSERT INTO db.mixtures (drug_id, solvent, muxture_type_id) VALUES (%s, %s, %s)"
    val = (drug_id, solvent, mixture_type_id)
    cursor.execute(sql, val)


def insert_drugs(db: Union[PooledMySQLConnection, MySQLConnectionAbstract], cursor: MySQLCursorAbstract) -> None:
    cursor.execute('DELETE FROM db.pills')
    cursor.execute('DELETE FROM db.salves')
    cursor.execute('DELETE FROM db.tinctures')
    cursor.execute('DELETE FROM db.mixtures')
    cursor.execute('DELETE FROM db.solutions')
    cursor.execute('DELETE FROM db.powders')
    cursor.execute('DELETE FROM db.drugs')
    db.commit()

    f = Food(Locale.RU)

    names = ['НевроКалм', 'КардиоСтронг', 'ГастроЗащита', 'ИммуноБустер', 'Детофикс', 'РадиантСкорбуцин', 'ОстеоСтронг', 'ПульмоКлин', 'РеноVita', 'ГемоОптим', 'АллергоСтоп', 'СомноРелакс', 'Профилектум', 'МетаТир', 'ГиполипоКлин', 'ДермаЦел', 'Антиартроз', 'ДиабетоКонтрол', 'ГастроПротект', 'УроПрофилактин']
    descriptions = ['препарат для устранения неврологических болей и тревожности', 'средство для укрепления сердечной мышцы и снижения давления', 'лекарство от защиты желудочно-кишечного тракта', 'препарат для усиления иммунитета', 'средство для вывода токсинов из организма', 'витаминный комплекс для красоты и здоровья кожи', 'препарат для укрепления костей', 'лекарство от заболеваний легких', 'препарат для улучшения работы почек', 'средство для нормализации кровообращения', 'лекарство от аллергии', 'средство для улучшения сна и борьбы со стрессом', 'препарат для профилактики вирусных заболеваний', 'лекарство для нормализации работы щитовидной железы', 'препарат для снижения холестерина', 'средство для улучшения состояния кожи', 'лекарство от болей в суставах', 'препарат для контроля уровня сахара в крови', 'средство для защиты слизистой оболочки желудка', 'лекарство для профилактики заболеваний мочевыводящей системы']

    for i in range(DRUGS_COUNT):
        drug_id = i + 1

        drug_type_id = random.randint(1, 6)
        insert_drug(
            cursor=cursor,
            drug_id=drug_id,
            name=names[i],
            cost=random.randint(2, 100) * 100 - 1,
            shelf_life=random.randint(1, 30) * 24,
            critical_amount=random.randint(0, 50),
            type_id=drug_type_id,
            description=descriptions[i]
        )

        if drug_type_id == 1:
            weight_of_pill = random.randint(1, 10) * 10
            insert_pills(
                cursor=cursor,
                drug_id=drug_id,
                weight_of_pill=weight_of_pill,
                total_weight=random.randint(2, 50) * weight_of_pill
            )
        if drug_type_id == 2:
            insert_salve(
                cursor=cursor,
                drug_id=drug_id,
                active_substance=f.vegetable(),
            )
        if drug_type_id == 3:
            insert_tincture(
                cursor=cursor,
                drug_id=drug_id,
                material=f.fruit()
            )
        if drug_type_id == 4:
            insert_mixture(
                cursor=cursor,
                drug_id=drug_id,
                solvent=f.drink(),
                mixture_type_id=random.randint(1, 3)
            )
        if drug_type_id == 5:
            insert_solution(
                cursor=cursor,
                drug_id=drug_id,
                dosage=random.randint(1, 99)
            )
        if drug_type_id == 6:
            insert_powder(
                cursor=cursor,
                drug_id=drug_id,
                is_composite=bool(random.randint(0, 1))
            )

    db.commit()
