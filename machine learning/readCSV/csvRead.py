import csv

def grabRelevantPlants(filename, plantList):
    with open(filename, "rt") as csvfile:
        datareader = csv.reader(csvfile, delimiter=';')
        yield next(datareader)
        yield from filter(lambda r: grabGenericName(r[3]) in plantList, datareader)
        return
    
def grabGenericName(name):
    name = name.split(' ')
    return name[0]+' '+name[1]

def main():
    testList = ['Cycas calcicola','Cycas circinalis']
    for row in grabRelevantPlants(r"C:\Users\michi\Desktop\school\inisensiot\project\machine learning\code\readCSV\testCSV.csv", testList):
        print(row[0]+','+row[3])
        print("\n")

main()