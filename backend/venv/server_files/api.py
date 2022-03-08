from turtle import update
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


@app.route("/")
def home():
  return "I am UP :)"

# USER SIGN UP
@app.route("/api/user_signup")
def userSignup():
  username = request.args.get('username')
  email = request.args.get('email')
  imageurl = None

  # perform form validation here......
  # username shouldn't be null and email should comply with apt regex
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
  # username shouldn't be null and email should comply with apt regex
  if (username != None and email != None):
    docs = db.collection("organizer").where("email", "==", email).get()
    if len(docs) == 0:
      db.collection("organizer").document().set({"username": username, "email": email, "imageurl": imageurl, "special": special, "amountGiven":amountGiven, "rating": rating})
      return "Success"
  
  return "Failed"


# REGISTER PUBG
@app.route("/api/register/pubg")
def register():
  matchuid = request.args.get("matchuid") 
  useruid = request.args.get("useruid")
  
  # perform some validation here.......
  # check for valid matchuid
  # check for already registered
  # if not, increase reg of the match, update registered matches of user
  # create a separate table of users who are registered for that match

  if (matchuid != None and useruid != None):
    ref = db.collection("pubg").document(matchuid)

    # retrieve the total registered and update the value to one [USE TRANSACTION!]
    transaction = db.transaction()
    @firestore.transactional
    def updateRegisteredTeams(transaction, ref):
      snapshot = ref.get(transaction = transaction)
      reg = snapshot.get("reg")
      try:
        if reg < 100:
          transaction.update(ref, {"reg": reg + 1})
          return True
        else:
          return False
      except:
        return False

    
    result = updateRegisteredTeams(transaction, ref)

    if result:
      return "Success"
    else:
      return "Failed"

  return "Failed"




app.run(debug=True)
