import sqlite3
import os.path
from bokeh.io import output_file, show
from bokeh.plotting import figure

##### #####
"""
db = sqlite3.connect('Project.db')
cur = db.cursor()
"""        
##### Upper doesn't work even though the files are in same folder #####
BASE_DIR = os.path.dirname(os.path.abspath(__file__))
db_path = os.path.join(BASE_DIR, "Project.db")
with sqlite3.connect(db_path) as db:
    cur = db.cursor()
##### #####

def initializeDB():
    try:
        ##### Same here #####
        #f = open("SQLqueries.sql", "r")
        ##### #####
        BASE_DIR = os.path.dirname(os.path.abspath(__file__))
        f_path = os.path.join(BASE_DIR, "SQLqueries.sql")
        f = open(f_path, "r")
        ##### #####
        commandstring = ""
        for line in f.readlines():
            commandstring+=line
        cur.executescript(commandstring)
    except sqlite3.OperationalError:
        print("Database exists, skip initialization")
    except:
        print("No SQL file to be used for initialization") 


def main():
    initializeDB()
    userInput = -1
    while(userInput != "0"):
        print("\nMenu options:")
        print("1: Update catcher title")
        print("2: Delete dead fish")
        print("3: Insert new Area")
        print("4: Print all caught fish")
        print("5: Show vizualisation of fish based on type")
        print("0: Quit")
        userInput = input("What do you want to do? ")
        print(userInput)
        if userInput == "1":
            Updater()
        if userInput == "2":
            Delete()
        if userInput == "3":
            newArea()
        if userInput == "4":
            joinClause()
        if userInput == "5":
            bokehfunction()
        if userInput == "0":
            print("Ending software...")
    db.close() 
    return


def Updater():
    CatcherID = input("What is your CatcherID? ")
    

    print("Your previous info:")
    cur.execute("SELECT CatcherID, Title, First_name, Last_name FROM Catcher WHERE CatcherID = (?);", (CatcherID,))
    results = cur.fetchall()
    for row in results:
        print(row)

    newTitle = input("What is your new Title? ")

    cur.execute("UPDATE Catcher SET Title = (?) WHERE CatcherID = (?);", (newTitle, CatcherID))
    db.commit()

    print("Your updated info:")
    cur.execute("SELECT CatcherID, Title, First_name, Last_name FROM Catcher WHERE CatcherID = (?);", (CatcherID,))
    results = cur.fetchall()
    for row in results:
        print(row)

    return

def Delete():
    FishID = input("What is the FishID? ")

    cur.execute("DELETE FROM Fish WHERE FishID = (?);", (FishID,))
    db.commit()

    return   

def newArea():
    

    print("List of previous areas:")
    print("(PostalCode, City abbreviation)")
    cur.execute("SELECT PostalCode, City FROM Area;")
    results = cur.fetchall()
    for row in results:
        print(row)
    
    newPostalCode = input("What is the new Postal Code? ")
    newCity = input("What is the new City abbreviation? ")

    cur.execute("INSERT INTO Area(PostalCode, City) VALUES ((?), (?));", (newPostalCode, newCity))
    db.commit()

    print("List after insert:")
    print("(PostalCode, City abbreviation)")
    cur.execute("SELECT PostalCode, City FROM Area;")
    results = cur.fetchall()
    for row in results:
        print(row)

    return

def joinClause():

    cur.execute("""SELECT CaughtBy.FishID AS 'ID', Fish.Kind AS 'Type', CaughtBy.CatchDate AS 'Catch Date', Area.City FROM CaughtBy \
    INNER JOIN Fish ON CaughtBy.FishID = Fish.FishID \
    INNER JOIN Area ON CaughtBy.AreaID = Area.AreaID \
    ORDER BY CaughtBy.FishID;""")
    
    results = cur.fetchall()
    print("(ID, Type, Catch Date, City abbreviation)")
    for row in results:
        print(row)

    return

def bokehfunction():
    output_file("fish.html")

    fish = []
    counts = []

    for row in cur.execute("SELECT Fish.Kind, COUNT(*) AS COUNT FROM Fish GROUP BY Fish.Kind;"):
        fish.append(str(row[0]))
        counts.append((row[1]))

    p = figure(x_range=fish, height=250, title="Fish counts on types",
           toolbar_location=None, tools="")

    p.vbar(x=fish, top=counts, width=0.9)

    p.xgrid.grid_line_color = None
    p.y_range.start = 0

    show(p)

    return

main()