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


    def print_result(self, stdscr, result:list, col_names=None, selected_row_idx=None):
        res = result.copy()

        stdscr.clear()
        h, w = stdscr.getmaxyx()

        stdscr.addstr(0,0, str(res))

        # insert header
        if col_names:
            res.insert(0, self.menu_top_line)
            res.insert(0, col_names)

        # print lines
        for idx, row in enumerate(res):
            string = ""

            # check for nested rows
            if isinstance(row, list):
                for col in row:
                    col = str(col).capitalize()
                    string += f"| {col:<15}"
            else:
                string = row

            # get width of first item
            if idx == 0:
                width = len(string) 
            x = w//2 - width//2
            y = h//2  - len(res)  // 2 + idx

            # mark the selected row
            if idx == selected_row_idx:
                stdscr.attron(curses.color_pair(1))
                stdscr.addstr(y, x, str(string))
                stdscr.attroff(curses.color_pair(1))
            else:
                stdscr.addstr(y, x, str(string))
            # print
            stdscr.refresh()


    def print_center(self, stdscr, text):
        stdscr.clear()
        h, w = stdscr.getmaxyx()
        x = w//2 - len(text)//2
        y = h//2
        stdscr.addstr(y, x, text)
        stdscr.refresh()


    def main(self, stdscr):
        # turn off cursor blinking
        curses.curs_set(0)

        # color scheme for selected row
        curses.init_pair(1, curses.COLOR_BLACK, curses.COLOR_WHITE)

        # specify the current selected row
        current_row = 0
        active_menu = self.menu

        # print the menu
        # self.print_menu(stdscr, current_row)
        self.print_result(stdscr, active_menu, current_row)


        # main loop
        while 1:
            key = stdscr.getch()

            if key == curses.KEY_UP and current_row > 0:
                current_row -= 1

        # TODO the menu selector is offset
            elif key == curses.KEY_DOWN and current_row < len(active_menu)-1:
                current_row += 1

            elif key == curses.KEY_ENTER or key in [10, 13]:

                """ if current_row == self.menu.index("Get available rental instruments"):
                    res, col = self.get_available_rental_instruments()
                    active_menu = [res, col]
                    current_row = 0
         """
                # if user selected last row, exit the program
                if current_row == self.menu.index("Exit"):
                    break
                
                stdscr.getch()
                active_menu = self.menu

            prints(stdscr, active_menu)
            self.print_result(stdscr, active_menu, current_row)






    def get_available_rental_instruments(self) -> list:
        return self.ctrl.get_available_rental_instruments()

    def create_rental(self, student_id:int, rental_instrument:int, start_date:date, months_to_rent:int):
        self.ctrl.create_rental(student_id, rental_instrument, start_date, months_to_rent)

    def student_rentals(self, student_id:int) -> list:
        return self.ctrl.student_rentals(student_id)

    def terminate_rental(self, rental_id:int):
        self.ctrl.terminate_rental(rental_id)


def prints(stdscr, shit):
    stdscr.addstr(str(shit))
    stdscr.refresh()

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






