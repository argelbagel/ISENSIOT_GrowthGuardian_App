import tensorflow as tf
import cv2 as cv
import pathlib
import sys
# Load TFLite model and allocate tensors.
interpreter = tf.lite.Interpreter(model_path="model.tflite")
# Get input and output tensors.
input_details = interpreter.get_input_details()
output_details = interpreter.get_output_details()
#print(interpreter.shape())
# input details
print(input_details)
# output details
print(output_details)
interpreter.allocate_tensors()

labelFile = open("labels.txt", "r")
labels = [line.rstrip() for line in labelFile.readlines()]
labelFile.close()
print(labels)

found = 0
notFound = 0
foundLabels = []

for file in pathlib.Path('testData').iterdir():
    # read and resize the image
    img = cv.imread(r"{}".format(file.resolve()))
    new_img = cv.resize(img, (224, 224))
    
    interpreter.set_tensor(input_details[0]['index'], [new_img])
    interpreter.invoke()
    output_data = interpreter.get_tensor(output_details[0]['index'])
    founLabel = False
    for i in range(0,len(labels)):
        if(output_data[0][i] > 150):
            print(labels[i])
            founLabel = True
            found+= 1
            if labels[i] not in foundLabels:
                foundLabels.append(labels[i])
    if founLabel == False:
        notFound+=1
        print("not found")
print('found: '+str(found))
print('not found: '+str(notFound))
print(foundLabels)
print(len(foundLabels))