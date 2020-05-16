from flask import jsonify, request
from .. import app
from ..models import Users
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
			current_user = Users.query.filter_by(uid=data['uid']).first()
		except jwt.ExpiredSignature:
			return jsonify({'error': 'token expired'})
		except jwt.DecodeError:
			return jsonify({"error": "token is invalid"})
	
		return f(current_user, *args, **kwargs)
	
	return decorator

def generate_token(user):
	return jwt.encode({
		'uid': user.uid,
		"username": user.username,
		'exp' : datetime.datetime.utcnow() + datetime.timedelta(minutes=30)},
		app.config['SECRET_KEY']).decode()