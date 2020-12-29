#! /usr/local/bin/python3

from Model import Model
from datetime import datetime


class Controller(object):
    def __init__(self, model:Model):
        self.model = model
        print("Hello controller!")

    @classmethod
    def get_available_rental_instruments() -> str:  # JSON
        pass

    @classmethod
    def create_rental(student_id:int, rental_instrument:int, start_date:datetime, months_to_rent:int):
        pass

    @classmethod
    def student_rentals(student_id:int) -> str:     # JSON
        pass

    @classmethod
    def terminate_rental(rental_id:int):
        pass