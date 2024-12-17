import tensorflow as tf
"""model = tf.keras.models.load_model('Fruit_Quality_Classification_Model.keras')
conv = tf.lite.TFLiteConverter.from_keras_model(model)
tflite_model = conv.convert()
with open('example_model.tflite', 'wb') as f:
    f.write(tflite_model)

"""
interpreter = tf.lite.Interpreter(model_path="example_model.tflite")
interpreter.allocate_tensors()

# Print input shape and type
inputs = interpreter.get_input_details()
print('{} input(s):'.format(len(inputs)))
for i in range(0, len(inputs)):
    print('{} {}'.format(inputs[i]['shape'], inputs[i]['dtype']))

# Print output shape and type
outputs = interpreter.get_output_details()
print('\n{} output(s):'.format(len(outputs)))
for i in range(0, len(outputs)):
    print('{} {}'.format(outputs[i]['shape'], outputs[i]['dtype']))