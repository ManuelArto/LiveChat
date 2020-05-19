from flask_socketio import emit, send
from flask import request
import json
from .. import socketio
from .jwt import get_username, token_required

socket_clients = {}

@socketio.on("connect", namespace="/socketio")
def handle_connect():
	username = get_username(request.args.get("token"))
	print(f"[NEW USER] {username}")

@socketio.on('send_message', namespace='/socketio')
def handle_msg(json_data):
	print("received")
	json_data = json.loads(json_data)
	data = {"sender": get_username(json_data["token"]), "receiver": json_data["receiver"], "message": json_data["message"]}
	emit('receive_message', data, broadcast=True, include_self=False)

@socketio.on('disconnect', namespace='/socketio')
def disconnect():
	print('Client disconnected')