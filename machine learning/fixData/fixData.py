def readFile(fileName):
    file = open(fileName, "r")
    returnValue = file.readlines()
    file.close()
    return returnValue

def writeLine(fileName, line):
    file = open(fileName, "a")
    file.write(line)
    file.close()

def main():
    allPlants = readFile(r"C:\Users\michi\Desktop\school\inisensiot\project\machine learning\code\fixData\desiredPlants.txt")
    for plant in allPlants:
        if("hybrid" in plant.lower() or "family" in plant.lower() or "speci" in plant.lower()):
            writeFile = r"C:\Users\michi\Desktop\school\inisensiot\project\machine learning\code\fixData\hybridsAndFamilies.txt"
        else:
            writeFile = r"C:\Users\michi\Desktop\school\inisensiot\project\machine learning\code\fixData\goodPlants.txt"
        writeLine(writeFile, plant)

main()