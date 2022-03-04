from email.mime import image
from flask import Flask
from flask import request
import json
import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore

# Use a service account
cred = credentials.Certificate('zbgaming-v1-firebase-adminsdk-2ozhj-4f38e5fc3e.json')
firebase_admin.initialize_app(cred)

db = firestore.client()

app = Flask(__name__)


# USER SIGN UP
@app.route("/user_signup")
def home():
  username = request.args.get('username')
  email = request.args.get('email')
  imageurl = None

  if (username != None and email != None):
    db.collection("userinfo").document().set({"username": username, "email": email, "imageurl": imageurl})

  return "Will add futures to it. Right now it is static :("

app.run(debug=True)
