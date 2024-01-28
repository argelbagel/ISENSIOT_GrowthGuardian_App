import csv

csvFilePath = r"C:\Users\michi\Desktop\school\inisensiot\project\machine learning\code\readCSV\PlantCLEF2022_trusted_training_metadata.csv"
outPutPath = r"C:\Users\michi\Desktop\school\inisensiot\project\machine learning\code\readCSV\usefulPlants.txt"
plantFile = open(r"C:\Users\michi\Desktop\school\inisensiot\project\machine learning\code\readCSV\hybrids.txt")
plantList = plantFile.read().splitlines()
plantFile.close()

def grabRelevantPlants():
    with open(csvFilePath, "rt", encoding="utf8") as csvfile:
        datareader = csv.reader(csvfile, delimiter=';')
        yield next(datareader)
        yield from filter(lambda r: grabGenericName(r[3]) in plantList, datareader)
        return
    
def grabGenericName(name):
    name = name.split(' ')
    return name[0]+' '+name[1]

def grabGenericNameSingleName(name, index):
    return name.split(' ')[index]

def writeLine(line):
    file = open(outPutPath, "a")
    file.write(line)
    file.close()

def main():
    foundIds = []
    for row in grabRelevantPlants():
        if(row[0]not in foundIds):
            foundIds.append(row[0])
            writeLine(row[0]+','+row[3]+'\n')

main()