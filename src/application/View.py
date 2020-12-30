#! /usr/local/bin/python3


from Controller import Controller
from datetime import date
import curses
import sys




class View(object):
    menu = ['Get available rental instruments', 'Make a rental', 'Get students rentals', 'Terminate a rental', 'Exit']
    menu_top_line = ['--------------', '--------------', '--------------', '--------------',]

    

    def __init__(self, ctrl:Controller):
        self.ctrl = ctrl
        print("Hello view!!")
        curses.wrapper(self.main)
    
    


    def print_menu(self, stdscr, selected_row_idx):
        stdscr.clear()
        h, w = stdscr.getmaxyx()
        for idx, row in enumerate(self.menu):
            x = w//2 - len(self.menu[0])//2
            y = h//2 - len(self.menu)//2 + idx
            if idx == selected_row_idx:
                stdscr.attron(curses.color_pair(1))
                stdscr.addstr(y, x, row)
                stdscr.attroff(curses.color_pair(1))
            else:
                stdscr.addstr(y, x, row)
        stdscr.refresh()


    def print_result(self, stdscr, result:list, col_names=None, selected_row_idx=-100000, messages:list=None):
        res = result.copy()
        stdscr.clear()
        h, w = stdscr.getmaxyx()
        stdscr.addstr(0,0, str("Nu kör vi killen!"))

        # insert header
        res.insert(0, self.menu_top_line)
        res.insert(0, col_names)

        if messages:
            i = len(messages)
            for message in messages:
                self.print_center(stdscr, message, (h//2 - len(res)// 2) -i -2)

        # print lines
        width = 0
        for idx, row in enumerate(res):
            string = self.row_to_string(row)

            # get width of first item
            if idx == 0:
                width = len(string) 
            x = w//2 - width//2
            y = h//2  - len(res)  // 2 + idx

            # mark the selected row
            if idx == selected_row_idx +2:
                stdscr.attron(curses.color_pair(1))
                stdscr.addstr(y, x, str(string))
                stdscr.attroff(curses.color_pair(1))
            else:
                stdscr.addstr(y, x, str(string))
            # print
            stdscr.refresh()
            

    @staticmethod
    def row_to_string(row) -> str:
        string = ""
        for col in row:
            col = str(col).capitalize()
            string += f"| {col:<15}"
        return string

    @staticmethod
    def print_center(stdscr, text, y=None):
        # stdscr.clear()
        h, w = stdscr.getmaxyx()
        x = w//2 - len(text)//2
        if not y:
            y = h//2
        stdscr.addstr(y, x, text)
        # stdscr.refresh()


    def main(self, stdscr):
        # turn off cursor blinking
        curses.curs_set(0)

        # color scheme for selected row
        curses.init_pair(1, curses.COLOR_BLACK, curses.COLOR_WHITE)

        self.main_menu(stdscr)


    def main_menu(self, stdscr):
        current_row = 0
        self.print_menu(stdscr, current_row)
        while 1:
            key = stdscr.getch()
            if key == curses.KEY_UP and current_row > 0:
                current_row -= 1
            elif key == curses.KEY_DOWN and current_row < len(self.menu)-1:
                current_row += 1
            elif key == curses.KEY_ENTER or key in [10, 13]:
                if current_row == self.menu.index("Get available rental instruments"):
                    res, col = self.get_available_rental_instruments()
                    self.print_result(stdscr, result=res, col_names=col)
                    stdscr.getch()
                if current_row == self.menu.index("Make a rental"):
                    self.rental_menu(stdscr)
                if current_row == self.menu.index("Exit"):
                    break
            self.print_menu(stdscr, selected_row_idx=current_row)

    def rental_menu(self, stdscr):
        current_row = 0
        res, col = self.get_available_rental_instruments()
        message = ["Choose the instrument you want to rent."]
        self.print_result(stdscr, result=res, col_names=col, selected_row_idx=current_row, messages=message)
        while 1:
            key = stdscr.getch()
            if key == curses.KEY_UP and current_row > 0:
                current_row -= 1
            elif key == curses.KEY_DOWN and current_row < len(res)-1:
                current_row += 1
            elif key == curses.KEY_ENTER or key in [10, 13]:
                self.make_rental(stdscr, res[current_row], col)
            elif key == ord('b'):
                return
            self.print_result(stdscr, result=res, col_names=col, selected_row_idx=current_row, messages=message)


    def make_rental(self, stdscr, instrument, col_names):
        instrument = [instrument]
        message = ["Do you want to rent this instrument? Press y or n (yes or no)"]
        self.print_result(stdscr, result=instrument, col_names=col_names, messages=message)
        key = stdscr.getch()
        if key == ord('y'):
            student_id = self.get_student(stdscr)
            self.create_rental()
            
    def get_student(self, stdscr) -> int:
        stdscr.clear()
        id = 1
        self.print_center(stdscr, "Enter your student id", 15)
        self.print_center(stdscr, str(id), 16)
        while 1:
            key = stdscr.getch()
            if key == curses.KEY_UP and id > 1:
                id -= 1
            elif key == curses.KEY_DOWN and id < 100:
                id += 1
            elif key == curses.KEY_ENTER or key in [10, 13]:
                return id
            stdscr.clear()
            self.print_center(stdscr, "Enter your student id", 15)
            self.print_center(stdscr, str(id), 16)
            stdscr.refresh()


    def get_available_rental_instruments(self) -> list:
        return self.ctrl.get_available_rental_instruments()

    def create_rental(self, student_id:int, rental_instrument:int, start_date:date, months_to_rent:int):
        self.ctrl.create_rental(student_id, rental_instrument, start_date, months_to_rent)

    def student_rentals(self, student_id:int) -> list:
        return self.ctrl.student_rentals(student_id)

    def terminate_rental(self, rental_id:int):
        self.ctrl.terminate_rental(rental_id)


def prints(stdscr, shit):
    stdscr.addstr(20,0,shit)
    stdscr.refresh()
    stdscr.getch()

""" to print to console """
class StdOutWrapper:
    text = ""
    def write(self,txt):
        self.text += txt
        self.text = '\n'.join(self.text.split('\n')[-30:])
    def get_text(self):
        return '\n'.join(self.text.split('\n'))

if __name__ == "__main__":
    from DatabaseHandler import DatabaseHandler
    from Model import Model
    db = DatabaseHandler()
    model = Model(db)
    ctrl = Controller(model)
    
    view = View(ctrl)






