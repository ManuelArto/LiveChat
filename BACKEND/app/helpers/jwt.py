from flask import jsonify, request
from app import app
import datetime
from functools import wraps
import jwt

EXP_TOKEN = datetime.timedelta(minutes=30)
EXP_REFRESH_TOKEN = datetime.timedelta(hours=4)

def token_required(f):
	@wraps(f)
	def decorator(*args, **kwargs):
		
		token = request.headers['x-access-tokens'] if 'x-access-tokens' in request.headers else None

		if not token:	
			return jsonify({'error': 'a valid token is missing'})
		try:
			data = jwt.decode(token, app.config["SECRET_KEY"])
		except jwt.ExpiredSignature:
			return jsonify({'error': 'token expired'})
		except jwt.DecodeError:
			return jsonify({"error": "token is invalid"})
	
		return f(data, *args, **kwargs)
	
	return decorator

def get_data(token, verify):
	try:
		data = jwt.decode(token, app.config["SECRET_KEY"], verify=verify)
		return data["username"], f"https://firebasestorage.googleapis.com/v0/b/livechat-e7db8.appspot.com/o/profileIcons%2F{data['uid']}.jpg?alt=media"
	except:
		return None, None
	
def generate_token(user):
	return jwt.encode({
		'uid': user.uid,
		"username": user.username,
		"iat": datetime.datetime.utcnow(),
		'exp': datetime.datetime.utcnow() + EXP_TOKEN},
		app.config['SECRET_KEY']).decode(), EXP_TOKEN.seconds 

def generate_refresh_token(user):
	return jwt.encode({
		'uid': user.uid,
		"iat": datetime.datetime.utcnow(),
		'exp': datetime.datetime.utcnow() + EXP_REFRESH_TOKEN},
		app.config['SECRET_KEY']).decode(), EXP_REFRESH_TOKEN.seconds
