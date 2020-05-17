from werkzeug.security import generate_password_hash, check_password_hash
import uuid
from . import db
from .endpoint.jwt import generate_refresh_token, generate_token

class Users(db.Model):
	__tablename = "USERS"
	id = db.Column(db.Integer, primary_key=True)
	uid = db.Column(db.String(50), unique=True)
	email = db.Column(db.String(50), unique=True)
	username = db.Column(db.String(50), unique=True)
	password = db.Column(db.String(80), unique=True)

	def __init__(self, email, username, password):
		self.uid = str(uuid.uuid4())
		self.email = email
		self.username = username
		self.password = generate_password_hash(password, method="SHA256")


	def check_password(self, password):
		return check_password_hash(self.password, password)

	def __repr__(self):
		return '<id {}>'.format(self.uid)
    
	def serialize(self):
		return {"user": {"uid": self.uid, "username":self.username, "token": generate_token(self), "refresh_token": generate_refresh_token(self)}}
