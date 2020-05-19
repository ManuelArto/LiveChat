from flask import request, jsonify
from sqlalchemy import exc
from .. import app, db
from ..models import Users
from .jwt import token_required
import datetime

@app.route("/api/login", methods=["POST"])
def login():
	try:
		data = request.get_json(force=True)
		user = Users.query.filter_by(email=data["email"]).first()
		if not user:
			return jsonify({"error": "No user with that email"}), 403
		if not user.check_password(data["password"]):
			return jsonify({"error": "Wrong password"}), 403

		return jsonify(user.serialize())
		
	except KeyError as e:
		return jsonify({"error": f"Missing {str(e)}"})
	except Exception as e:
		return jsonify({"error": str(e)})

@app.route("/api/register", methods=["POST"])
def signup():
	data = request.get_json(force=True)
	try:
		new_user = Users(email=data["email"], username=data["username"], password=data["password"])
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
	curret_user = Users.query.filter_by(uid=data["uid"]).first()
	return jsonify(curret_user.serialize())

@app.route("/private")
@token_required
def private(data):
	current_user = Users.query.filter_by(uid=data["uid"]).first()
	return jsonify({"user": [current_user.username, current_user.uid]})