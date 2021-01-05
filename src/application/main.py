#! /usr/local/bin/python3

from Integration.DatabaseHandler import DatabaseHandler
from Model.Model import Model
from Controller.Controller import Controller
from View.View import View

if __name__ == "__main__":
    # dbhandler
    dbhandler = DatabaseHandler()
    # model
    model = Model(dbhandler)
    # controller
    controller = Controller(model)
    # view
    view = View(controller)