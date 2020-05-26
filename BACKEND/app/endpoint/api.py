from flask import request, jsonify
from sqlalchemy import exc
from app import app, db
from app.models import Users
from app.helpers.jwt import token_required
from app.helpers import firebase
import datetime
import base64

@app.route("/api/login", methods=["POST"])
def login():
	try:
		data = request.get_json(force=True)
		user = Users.query.filter_by(email=data["email"]).first()
		if not user:
			return jsonify({"error": "No user with that email"}), 403
		if not user.check_password(data["password"]):
			return jsonify({"error": "Wrong password"}), 403
	except KeyError as e:
		return jsonify({"error": f"Missing {str(e)}"})
	except Exception as e:
		return jsonify({"error": str(e)})

	return jsonify(user.serialize())

@app.route("/api/register", methods=["POST"])
def signup():
	try:
		data = request.get_json(force=True)
		new_user = Users(email=data["email"], username=data["username"], password=data["password"])
		firebase.upload_image(new_user.uid, base64.decodebytes(data["imageFile"].encode()))
		db.session.add(new_user)
		db.session.commit()
	except exc.IntegrityError:
		return jsonify({"error": "duplicate key value"}), 403
	except KeyError as e:
		return jsonify({"error": f"Missing {str(e)}"})
	except Exception as e:
		return jsonify({"error": str(e)})

	return jsonify(new_user.serialize()), 201

@app.route("/api/refresh-token", methods=["POST"])
@token_required
def refresh_token(data):
	current_user = Users.query.filter_by(uid=data["uid"]).first()
	return jsonify(current_user.serialize())

@app.route("/private")
@token_required
def private(data):
	current_user = Users.query.filter_by(uid=data["uid"]).first()
	return jsonify({"user": [current_user.username, current_user.uid]})