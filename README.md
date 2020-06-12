# LiveChat
Livechat is cross-platform web application where users can authenticate and chat instantly. 

![preview](preview.gif)

## Usage
Click [here](https://manuelarto.github.io/livechat) to visit the web-app

Click [here](https://manuelarto.github.io/livechat/apk) to download the apk file

## Description
Livechat is a full-stack application that implement a cross-platform web application using [Flutter UI toolkit](https://flutter.dev/) and a Python server for authentication and instant messaging.

## Built with
* Flutter UI Toolkit
* Flask python microframework
* JsonWebTokens for authentication during each requets
* SocketIO for instant messaging
* PostgreSQL DB
* Firebase Storage (used for users profile icons)
* Heroku (used to host the server)

## Frontend
The application is developed using Flutter UI framework. From one codebase our app is then built for IOS/ ANDROID / WEB

#### SETUP
* Go to Frontend/LiveChatFrontend/:

* In "LiveChatFrontend/lib/constants.dart" are store the URLs for the python server, leave it default if you want to connect to the official server

```bash
$ flutter create .
$ flutter run 
```

## Backend
All users images are store on Firebase Storage

You need to have an Heroku account to host the server, but you can also run it locally.

#### SETUP
* Go to BACKEND/
* Create a new file '.env':
	```
	DATABASE_URL=YOUR_POSTGRESQL_DB_URL
	SECRET_KEY=this_must_be_secret
	DEBUG=True
	```
* Create a new virtual environment and install all dependencies
	```bash
	$ python -m venv venv
	$ source venv/bin/activate
	$ pip install -r requirements.txt
*  Create a new file 'app/helpers/firebase_config.py' and add your firebase project credentials:
	```python
	firebaseConfig = {
		"apiKey": "",
		"authDomain": "",
		"databaseURL": "",
		"projectId": "",
		"storageBucket": "",
		"messagingSenderId": "",
		"appId": "",
		"measurementId": ""
	}
	```
* Run the server
	```bash
	$ python wsgi.py
	```
