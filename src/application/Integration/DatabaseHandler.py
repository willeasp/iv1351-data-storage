#! /usr/local/bin/python3

""" 
Author: William Asp
January 2, 2021

This file handles the database calls. 
 """

import psycopg2
import json
from datetime import date
from psycopg2 import Error
from psycopg2 import sql
from psycopg2.extras import RealDictCursor
from decimal import Decimal


class DatabaseHandler(object):
    def __init__(self):
        self.db = self.initializePostgres()
        self.cursor = self.db.cursor()
        print("Hello database handler!")


    def get_available_rental_instruments(self) -> list:
        """ Get all rental instruments that can be rented """
        self.cursor.execute("""
            SELECT DISTINCT name, brand, monthly_cost, ri_id AS id
            FROM rental_instrument AS ri
            WHERE NOT EXISTS
            (SELECT 1 FROM rental AS r
            WHERE ri.ri_id = r.ri_id 
                AND CURRENT_DATE < end_date
                AND terminated IS NULL)
        """)
        self.db.commit()
        return self._cursor_result()

    
    def create_rental(self, student_id:int, rental_instrument:int, start_date:date, months_to_rent:int):
        """ Creates a rental in the database """
        try:
            s = start_date
            start_date = self.date_to_strf(s)
            # end_date = "{}-{:02d}-{:02d}".format(s.year, s.month + months_to_rent, s.day)
            self.cursor.execute(""" 
                INSERT INTO rental (start_date, end_date, student_id, ri_id)
                VALUES  (%s, %s::date + INTERVAL '%s month', %s , %s)
            """, [start_date, start_date, months_to_rent, student_id, rental_instrument])
            self.db.commit()
        except Exception as e:
            self.db.rollback()
            raise RuntimeError("No student found to be able to complete rental.")


    def student_rentals(self, student_id:int) -> list:
        """ Get a students currently active rentals """
        self.cursor.execute(""" 
            SELECT name, brand, monthly_cost, start_date, end_date, ri_id AS id, rental_id
            FROM rental
            NATURAL JOIN rental_instrument
            WHERE CURRENT_DATE < end_date 
                AND
                student_id = %s
                AND
                (CURRENT_DATE < terminated
                OR
                terminated IS NULL);
         """, [student_id])
        self.db.commit()
        return self._cursor_result()


    def terminate_rental(self, rental_id:int):
        """ Terminates a rental """
        try:
            self.cursor.execute(""" 
                UPDATE rental
                SET terminated = CURRENT_DATE
                WHERE rental_id = %s
            """, [rental_id])
            self.db.commit()
        except Exception as e:
            self.db.rollback()
            raise Exception(e)

    def get_rental(self, rental_id:int) -> list:
        self.cursor.execute(""" 
            SELECT *
            FROM rental
            WHERE rental_id = %s        
        """, [rental_id])
        self.db.commit()
        [res], col = self._cursor_result()
        return res


    def initializePostgres(self) -> psycopg2.extensions.connection:
        try:
            connection = psycopg2.connect(
                dbname="soundgood",
                user="postgres",
                host="dbsoundgood",
                password="example"
            )
        except (Exception, Error) as error:
            print("Error while connecting to PostgreSQL", error)
        finally:
            return connection


    def _cursor_result(self) -> list:
        return self.cursor.fetchall(), [desc[0] for desc in self.cursor.description]

    @staticmethod
    def date_to_strf(date:date):
        return date.strftime("%Y-%m-%d")
        

    def __del__(self):
        self.db.close()
        print("database connection closed")




if __name__ == "__main__":
    db = DatabaseHandler()
    # print(db.get_available_rental_instruments())

    # db.create_rental(1, 2, date(2020, 1, 2), 12)

    # print("student 3 rentals:")
    # print(db.student_rentals(3))

    db.terminate_rental(35)