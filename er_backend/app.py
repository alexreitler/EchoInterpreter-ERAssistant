from flask import Flask, request, jsonify
import tensorflow as tf
from io import BytesIO
import numpy as np
import cv2
app = Flask(__name__)
from tensorflow.keras.models import load_model

model =load_model('ImageClassification\models\imageclassifier.h5')  

@app.route('/predict', methods=['POST'])
def predict():
    if 'image' not in request.files:
        return jsonify({'error': 'No image provided'})

    img_file = request.files['image']
    
  
    img_bytes = BytesIO(img_file.read())
    img = cv2.imdecode(np.frombuffer(img_bytes.read(), np.uint8), cv2.IMREAD_COLOR)

    resize = tf.image.resize(img, (256,256))
    yhat = model.predict(np.expand_dims(resize/255, 0))

    if yhat > 0.5:
        result = {'class_probabilities': 'pneumothorax'}
    else:
        result={'class_probabilities': 'normal'}
    print(result['class_probabilities'])

    return jsonify(result)

if __name__ == '__main__':
    app.run(debug=True)
