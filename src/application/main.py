#! /usr/local/bin/python3

from DatabaseHandler import DatabaseHandler
from Model import Model
from Controller import Controller
from View import View

if __name__ == "__main__":
    # dbhandler
    dbhandler = DatabaseHandler()
    # model
    model = Model(dbhandler)
    # controller
    controller = Controller(model)
    # view
    view = View(controller)