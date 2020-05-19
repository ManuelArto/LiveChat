from flask import Flask 
from flask_socketio import SocketIO
from flask_sqlalchemy import SQLAlchemy
from flask_cors import CORS

app = Flask(__name__)
app.config.from_pyfile("config.py")

db = SQLAlchemy(app)

socketio = SocketIO(app, cors_allowed_origins="*")

from .endpoint import api
from .endpoint import websocket

CORS(app)

if __name__ == "__main__":
	socketio.run(app)