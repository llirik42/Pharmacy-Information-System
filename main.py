import os
from mysql.connector import connect, Error
from dotenv import load_dotenv

load_dotenv()

try:
    with connect(
            host=os.getenv("HOST"),
            user=os.getenv("USER"),
            password=os.getenv("PASSWORD")
    ) as conn:
        try:
            with conn.cursor() as curs:
                print(conn)
        except Error as error:
            print(error)

except Error as e:
    print(e)
