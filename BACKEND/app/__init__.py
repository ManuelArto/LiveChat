 
from flask import Flask 
from flask_socketio import SocketIO
from flask_sqlalchemy import SQLAlchemy

app = Flask(__name__)
app.config.from_pyfile("../config.py")

db = SQLAlchemy(app)

socketio = SocketIO(app)

from .endpoint import api
from .endpoint import websocket

if __name__ == "__main__":
    socketio.run(app, debug=True)