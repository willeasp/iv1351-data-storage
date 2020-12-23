#! /usr/local/bin/python3

import psycopg2
from psycopg2 import Error

try:
    connection = psycopg2.connect(
        dbname="soundgood",
        user="postgres",
        host="dbsoundgood",
        password="example"
    )

    print(connection)

    cursor = connection.cursor()
    # Print PostgreSQL details
    print("PostgreSQL server information")
    print(connection.get_dsn_parameters(), "\n")

    cursor.execute("SELECT version();")
    # Fetch result
    record = cursor.fetchone()
    print("You are connected to - ", record, "\n")

except (Exception, Error) as error:
    print("Error while connecting to PostgreSQL", error)
finally:
    if (connection):
        cursor.close()
        connection.close()
        print("PostgreSQL connection is closed")