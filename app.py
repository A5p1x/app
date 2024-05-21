from flask import Flask, jsonify, make_response

app = Flask(__name__)

@app.route('/green')
def green():
    return jsonify('GreenApi')

@app.route('/red')
def red():
    return jsonify('RedApi')

@app.route('/')
def blank():
    html_content = '''
    <html>
        <body>
            <p>You have the following APIs to use:</p>
            <ul>
                <li><a href="/red">Red API</a></li>
                <li><a href="/green">Green API</a></li>
            </ul>
        </body>
    </html>
    '''
    response = make_response(html_content)
    response.headers['Content-Type'] = 'text/html'
    return response

if __name__ == '__main__':
    app.run(debug=True, port=4949)

