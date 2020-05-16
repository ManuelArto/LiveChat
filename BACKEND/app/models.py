from werkzeug.security import generate_password_hash, check_password_hash
import uuid

from . import db

class Users(db.Model):
	__tablename = "USERS"
	id = db.Column(db.Integer, primary_key=True)
	uid = db.Column(db.String(50), unique=True)
	email = db.Column(db.String(50))
	username = db.Column(db.String(50))
	password = db.Column(db.String(80))

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
		return {
			'uid': self.uid, 
			'email': self.email,
			'username': self.username,
		}
