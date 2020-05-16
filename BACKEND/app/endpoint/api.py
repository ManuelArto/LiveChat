from flask import request, jsonify
from sqlalchemy import exc
from .. import app, db
from ..models import Users
from .jwt import generate_token, token_required
import datetime

@app.route("/api/login", methods=["POST"])
def login():
	try:
		data = request.get_json()
		user = Users.query.filter_by(email=data["email"]).first()
		if not user:
			return jsonify({"error": "No user with that email"}), 403
		if not user.check_password(data["password"]):
			return jsonify({"error": "Wrong password"}), 403
	except KeyError as e:
		return jsonify({"error": f"Missing {str(e)}"})

		return jsonify({"user": {"uid": user.uid, "username":user.username, "token": generate_token(user)}})

@app.route("/api/register", methods=["POST"])
def signup():
	data = request.get_json()  	
	try:
		new_user = Users(email=data["email"], username=data["username"], password=data["password"])
		db.session.add(new_user)
		db.session.commit()
	except exc.IntegrityError:
		return jsonify({"error": "duplicate key value"}), 403
	except KeyError as e:
		return jsonify({"error": f"Missing {str(e)}"})

	return jsonify({"user": {"uid": new_user.uid, "username":new_user.username, "token": generate_token(new_user)}}), 201