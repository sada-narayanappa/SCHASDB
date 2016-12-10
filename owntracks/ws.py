#!/anaconda/bin/python

from flask import Flask, request
from flask_restful import Resource, Api
from json import dumps

app = Flask(__name__)

def process():
    tags = [ t for t in request.args ];
    return str(tags);

@app.route('/ws')
def index():
    if (len(request.args) <= 0):
        return "Version 1.0";
    r = process();
    return r;


if __name__ == '__main__':
    app.run(debug=True, host="0.0.0.0", port=9000)
