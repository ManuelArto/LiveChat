from flask_socketio import emit, send, join_room, leave_room
from flask import request
import json
from .. import socketio
from .jwt import get_username, token_required

socket_clients = {}

@socketio.on("connect", namespace="/socketio")
def handle_connect():
	username = get_username(request.args.get("token"))
	if not username:
		return False
	socket_clients[username] = {"imageUrl" : "assets/images/profile_icon.jpg"}
	join_room(username)
	print(f"[NEW USER] {username}")
	emit("user_connected", socket_clients, broadcast=True)

@socketio.on('disconnect', namespace='/socketio')
def handle_disconnect():
	username = get_username(request.args.get("token"))
	if username in socket_clients:
		del socket_clients[username]
	leave_room(username)
	print(f'[USER DISCONNECTED] {username}')
	emit("user_disconnecred", {"username" : username}, broadcast=True, include_self=False)

@socketio.on('send_message', namespace='/socketio')
def handle_msg(json_data):
	print(f"[MESSAGE] {json_data}")
	json_data = json.loads(json_data)
	username = get_username(json_data["token"])
	if not username:
		return False
	data = {"sender": username, "receiver": json_data["receiver"], "message": json_data["message"]}
	if data["receiver"] == "GLOBAL":
		emit('receive_message', data, broadcast=True, include_self=False)
	else:
		emit("receive_message", data, room=data["receiver"])
