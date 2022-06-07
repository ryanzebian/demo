from flask import Flask,send_file, request
import numpy as np
import tensorflow as tf
import json

app = Flask(__name__,static_folder="static")
model = tf.keras.models.load_model("mnist.model")

@app.route("/",methods=["GET"])
def index():
    return send_file("./index.html")


@app.route("/guess",methods=["POST"])
def guess():
    buffer = request.get_data()
    img = np.frombuffer(buffer,dtype="uint8")
    print(img.shape)
    img = img.astype(dtype="float32") / 255
    img = np.expand_dims(img,axis=0)
    predictions = model.predict(img)
    number = predictions[0].argmax()
    confidence = predictions[0][number]
    print(number,confidence)
    print(predictions[0])
    
    return {
        "number": str(number),
        "confidence": str(confidence)
    }