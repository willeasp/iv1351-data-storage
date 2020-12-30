#! /usr/local/bin/python3

""" 
Author: William Asp
December 30, 2020

This class is the controller in the soundgood music school application.

 """
from Model import Model
from datetime import date


class Controller(object):
    def __init__(self, model:Model):
        self.model = model
        print("Hello controller!")

    def get_available_rental_instruments(self) -> list:
        return self.model.get_available_rental_instruments()

    def create_rental(self, student_id:int, rental_instrument:int, start_date:date, months_to_rent:int):
        self.model.create_rental(student_id, rental_instrument, start_date, months_to_rent)

    def student_rentals(self, student_id:int) -> list:
        return self.model.student_rentals(student_id)

    def terminate_rental(self, rental_id:int):
        self.model.terminate_rental(rental_id)


if __name__ == "__main__":
    from DatabaseHandler import DatabaseHandler
    db = DatabaseHandler()
    model = Model(db)
    ctrl = Controller(model)

    print(ctrl.get_available_rental_instruments())

    ctrl.create_rental(5, 5, date(2020, 5, 5), 12)

    ctrl.student_rentals(5)

    ctrl.terminate_rental(1)