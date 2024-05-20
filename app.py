from flask import Flask, jsonify

app = Flask(__name__)

@app.route('/green')
def green():
    return jsonify('GreenApi')

@app.route('/red')
def red():
    return jsonify('RedApi')

@app.route('/')
def blank():
    return jsonify('u have red or green api to use test')
if __name__ == '__main__':
    app.run(debug=True, port=4949)
