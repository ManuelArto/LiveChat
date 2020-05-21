from .firebase_config import firebaseConfig
import pyrebase

firebase = pyrebase.initialize_app(config=firebaseConfig)
storage = firebase.storage()

def upload_image(uid, image):
	response = storage.child(f"profileIcons/{uid}.jpg").put(image)

