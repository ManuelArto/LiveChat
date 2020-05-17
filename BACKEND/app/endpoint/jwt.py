from flask import jsonify, request
from .. import app
import datetime
from functools import wraps
import jwt

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

def generate_token(user):
	return jwt.encode({
		'uid': user.uid,
		"username": user.username,
		"iat": datetime.datetime.now(),
		'exp' : datetime.datetime.utcnow() + datetime.timedelta(minutes=30)},
		app.config['SECRET_KEY']).decode()

def generate_refresh_token(user):
	return jwt.encode({
		'uid': user.uid,
		"iat": datetime.datetime.now(),
		'exp' : datetime.datetime.utcnow() + datetime.timedelta(hours=8)},
		app.config['SECRET_KEY']).decode()