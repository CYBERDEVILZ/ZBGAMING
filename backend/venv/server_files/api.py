from flask import Flask
from flask import request
import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore

# FIREBASE INIT
cred = credentials.Certificate('zbgaming-v1-firebase-adminsdk-2ozhj-4f38e5fc3e.json')
firebase_admin.initialize_app(cred)
db = firestore.client()
app = Flask(__name__)


# USER SIGN UP
@app.route("/api/user_signup")
def userSignup():
  username = request.args.get('username')
  email = request.args.get('email')
  imageurl = None

  # perform form validation here......
  if (username != None and email != None):
    docs = db.collection("userinfo").where("email", "==", email).get()
    if len(docs) == 0:
      db.collection("userinfo").document().set({"username": username, "email": email, "imageurl": imageurl})
      return "Success"

  return "Failed"


# ORGANIZER SIGN UP
@app.route("/api/organizer_signup")
def organizerSignup():
  username = request.args.get('username')
  email = request.args.get('email')
  imageurl = None
  special = False
  amountGiven = 0
  rating = 0.0

  # perform form validation here.........
  if (username != None and email != None):
    docs = db.collection("organizer").where("email", "==", email).get()
    if len(docs) == 0:
      db.collection("organizer").document().set({"username": username, "email": email, "imageurl": imageurl, "special": special, "amountGiven":amountGiven, "rating": rating})
      return "Success"
  
  return "Failed"


# REGISTER
@app.route("/api/register")
def register():
  matchtype = request.args.get("matchtype")
  matchuid = request.args.get("matchuid")
  useruid = request.args.get("uuid")
  
  # perform some validation here.......
  # check for fees, authenticity, already registered
  if (matchuid != None and useruid != None):
    reg = 0
    db.collection(matchtype).doc(matchuid).update({"reg": reg + 1})
    return "Success"

  return "Failed"




app.run(debug=True)
