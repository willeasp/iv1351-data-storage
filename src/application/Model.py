#! /usr/local/bin/python3

""" 
Author: William Asp
30 December, 2020

This class is responsible for the soundgood music school's business rules.

"""

from DatabaseHandler import DatabaseHandler
from datetime import date


class Model(object):
    def __init__(self, dbhandler:DatabaseHandler):
        self.dbhandler = dbhandler
        print("Hello model!")

    
    def get_available_rental_instruments(self) -> list:  # JSON
        """ Get the available rental instruments """
        return self.dbhandler.get_available_rental_instruments()

    
    def create_rental(self, student_id:int, rental_instrument:int, start_date:date, months_to_rent:int):
        """ Create a rental if no more than 2 instruments have been rented """
        active_rentals = self.student_rentals(student_id)[0]
        if len(active_rentals) > 1:
            raise PermissionError(f"Student can not rent more instruments. Rented: {len(active_rentals)}")
        self.dbhandler.create_rental(student_id, rental_instrument, start_date, months_to_rent)

    
    def student_rentals(self, student_id:int) -> list:
        """ Get a students current rentals """
        return self.dbhandler.student_rentals(student_id)

    
    def terminate_rental(self, rental_id:int):
        """ Terminate a rental """
        terminated = self.dbhandler.get_rental(rental_id)[-1]   # the terminated column is last in the table
        if terminated:
            if terminated < date.today():
                raise Exception("Rental already terminated")

        

def _model_test():
    db = DatabaseHandler()
    model = Model(db)

    # test 1
    assert model.get_available_rental_instruments()

    # test 2
    try:
        model.terminate_rental(9)
        assert False
    except:
        assert True

    # test 3
    try:
        model.create_rental(4, 2, date.today(), 12)
        assert False
    except:
        assert True

    # test 4
    a, b = model.student_rentals(1)
    print(len(a))
    print(b)



if __name__ == "__main__":
    _model_test()