import os
from mysql.connector import connect, Error
from dotenv import load_dotenv

from insertion.customers import insert_customers
from insertion.doctors import insert_doctors
from insertion.drugs import insert_drugs
from insertion.orders import insert_orders
from insertion.orders_waiting_drug_supplies import insert_values
from insertion.patients import insert_patients
from insertion.prescriptions import insert_prescriptions
from insertion.prescriptions_content import insert_prescriptions_contents
from insertion.production import insert_production, insert_production_all
from insertion.reserved_drugs import insert_reserved_order_drugs
from insertion.storage_items import insert_storage_items
from insertion.suppliers import insert_suppliers
from insertion.supplies import insert_supplies
from insertion.technologies import insert_technologies
from insertion.technology_components import insert_technologies_components

load_dotenv()









try:
    with connect(
            host=os.getenv("HOST"),
            user=os.getenv("USER"),
            password=os.getenv("PASSWORD")
    ) as conn:
        try:
            with conn.cursor() as curs:
                pass
                # insert_doctors(conn, curs)
                # insert_customers(conn, curs)
                # insert_drugs(conn, curs)
                # insert_patients(conn, curs)
                # insert_supplies(conn, curs)
                # insert_storage_items(conn, curs)
                # insert_prescriptions(conn, curs)
                # insert_technologies(conn, curs)
                # insert_technologies_components(conn, curs)
                # insert_orders(conn, curs)
                # insert_production_all(conn, curs)
                # insert_values(conn, curs)
                # insert_values_2(conn, curs)
                # insert_reserved_order_drugs(conn, curs)
        except Error as error:
            print(error)

except Error as e:
    print(e)
