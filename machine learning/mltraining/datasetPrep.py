import numpy as np
import os
import PIL
import PIL.Image
import tensorflow as tf
import tensorflow_datasets as tfds
import pathlib
from tflite_model_maker import image_classifier
from tflite_model_maker.image_classifier import DataLoader

def prepDataset():
    mainPath = r"C:\Users\michi\Desktop\school\inisensiot\project\machine learning\code\mlTraining"
    data_dir = pathlib.Path(mainPath + "\smallDataset")

    data = DataLoader.from_folder(data_dir)
    train_data, test_data = data.split(0.9)

    # Customize the TensorFlow model.
    model = image_classifier.create(train_data)

    # Evaluate the model.
    loss, accuracy = model.evaluate(test_data)
    print(loss)
    print(accuracy)

    # Export to Tensorflow Lite model and label file in `export_dir`.
    model.export(export_dir= mainPath + "\decentModel", tflite_filename='model.tflite', label_filename='labels.txt')
    


def main():
    prepDataset()

main()