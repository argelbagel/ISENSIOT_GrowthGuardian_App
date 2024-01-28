import os
import requests
from bs4 import BeautifulSoup

plantListUrl = r"C:\Users\michi\Desktop\school\inisensiot\project\machine learning\code\imgScraping\checkedPlants.txt"
outputUrl = r"C:/Users/michi/Desktop/school/inisensiot/project/machine learning/code/imgScraping/dataset/"
onlineImageLocation = "https://lab.plantnet.org/LifeCLEF/PlantCLEF2022/train/trusted/images/"
backupFile = r"C:/Users/michi/Desktop/school/inisensiot/project/machine learning/code/imgScraping/backupFile.txt"

def readFile():
    file = open(backupFile, "r")
    returnValue = file.readlines()
    file.close()
    return returnValue

def manageBackup(list):
    file = open(backupFile, "w")
    file.writelines(list)
    file.close()

def scrapeImages():
    plantList = readFile()
    #del plantList[0]
    backUpList = plantList
    for plant in plantList:
        plantId,plantName = plant.split(",")
        plantName = plantName.strip()
        print(plantName)
        folderUrl = onlineImageLocation + plantId + "/"
        plantFolder = outputUrl+plantName+"/"
        if not os.path.exists(plantFolder):
            os.mkdir(plantFolder)
        allLinks = BeautifulSoup(requests.get(folderUrl).content, 'html.parser').findAll("a")
        for i in range(5,len(allLinks)):
            print(allLinks[i]["href"])
            if not os.path.exists(plantFolder+allLinks[i]["href"]):
                with open(plantFolder+allLinks[i]["href"], "wb") as image:
                    image.write(requests.get(onlineImageLocation + plantId + "/"+allLinks[i]["href"]).content) 
        backUpList.remove(plant)
        manageBackup(backUpList)


scrapeImages()