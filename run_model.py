from flask import Flask, render_template, request, jsonify
import tensorflow as tf
from PIL import Image
import numpy as np
import os

app = Flask(__name__)


@app.route('/')
def index():
    return render_template('index.html')

@app.route('/upload', methods = ['POST'])
def upload():
    if 'file' not in request.files:
        return jsonify({'error': 'No file was found'}),400
    file = request.files['file']
    if file.filename == '':
        return jsonify({'error': 'No selected file'}), 400
    if file:
        
        filename = file.filename
        file_path = os.path.join('UPLOAD_FOLDER', filename)
        file.save(file_path)
        print(file_path)
    
    
        width = 180
        height = 180
        ds_path = 'Fruit_dataset_v2/train'
        train_img_dataset = tf.keras.preprocessing.image_dataset_from_directory(ds_path, validation_split = 0.2, subset = "training", seed = 123, labels = "inferred", color_mode = 'rgb', image_size = (width, height),  batch_size = 32)
        class_names = train_img_dataset.class_names

        # classes are freshapples, freshbanana, freshoranges, rottenapples, rottenbanana, rottenoranges

        model = tf.keras.models.load_model("Fruit_Quality_Classification_Model.keras")
        img = Image.open(file_path)
        new_image = img.resize((180, 180))
        new_img_rgb = new_image.convert('RGB')
        img_array = np.array(new_img_rgb)
        predictions = model.predict(img_array[None,:,:,:])
        predicted_index = np.argmax(predictions, axis = 1)

        do_not_eat_mess = "It is NOT recommended to consume this product. It should be safely disposed of. Please note FQRC can make mistakes. Consider looking for important visuals for a spoiled food product."
        ok_to_eat_mess = "This product is considered to be fresh and safe to eat. Please note FQRC can make mistakes. Consider looking for important visuals for a spoiled food product."
        
        predicted_class = class_names[predicted_index[0]]
        if predicted_class == "freshapples":
            predicted_class = "fresh apple"
            after_detect_mess = ok_to_eat_mess
        elif predicted_class == "freshbanana":
            predicted_class = "fresh banana"
            after_detect_mess = ok_to_eat_mess
        elif predicted_class == "freshoranges":
            predicted_class = "fresh orange"
            after_detect_mess = ok_to_eat_mess
        elif predicted_class == "rottenapples":
            predicted_class = "rotten apple"
            after_detect_mess = do_not_eat_mess
        elif predicted_class == "rottenbanana":
            predicted_class = "rotten banana"
            after_detect_mess = do_not_eat_mess
        elif predicted_class == "rottenoranges":
            predicted_class = "rotten oranges"
            after_detect_mess = do_not_eat_mess

        

        response = f"A {predicted_class} was detected with {max(predictions[0]) * 100}% confidence. {after_detect_mess}"

    return jsonify({'message': response})
    

if __name__ == '__main__':
    app.run(debug=False)


