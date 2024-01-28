import numpy as np
import os
import PIL
import PIL.Image
import tensorflow as tf
import tensorflow_datasets as tfds
import pathlib
import cv2

mainFolderPath = r"C:\Users\michi\Desktop\school\inisensiot\project\machine learning\code\mlTraining\smallDataset"
outPutPath = r"C:\Users\michi\Desktop\school\inisensiot\project\machine learning\code\mlTraining\smallCorruptedImages.txt"

def testData():
    data_dir = pathlib.Path(mainFolderPath)
    for folder in list(data_dir.glob('*')):
        folderName = os.path.basename(folder)
        folderName = folderName.split(' ')[0] + ' ' + folderName.split(' ')[1]
        print(folderName)

        os.rename(folder,(mainFolderPath+'/'+folderName).encode('utf-8'))
        # for plant in list(data_dir.glob(folderName + '/*.jpg')):
        #     plantName = os.path.basename(plant)
        #     print(plantName)
        #     os.rename(plant,(mainFolderPath+'/'+folderName+'/'+plantName).encode('utf-8'))  

def writeCorrupted(line):
    file = open(outPutPath, "a")
    file.write(line)
    file.close()

def seeIfImageIsCorrupted():
    data_dir = pathlib.Path(mainFolderPath)
    for folder in list(data_dir.glob('*')):
        folderName = os.path.basename(folder)
        print(folderName)
        for plant in list(data_dir.glob(folderName + '/*.jpg')):
            plantName = os.path.basename(plant)
            if cv2.imread(mainFolderPath+'/'+folderName + '/' + plantName) is None:
                writeCorrupted(folderName + ","+plantName)

def main():
    seeIfImageIsCorrupted()

main()