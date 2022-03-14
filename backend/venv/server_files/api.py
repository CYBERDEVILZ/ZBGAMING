from datetime import datetime
from flask import Flask
from flask import request
import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore
import re

# FIREBASE INIT
cred = credentials.Certificate('zbgaming-v1-firebase-adminsdk-2ozhj-4f38e5fc3e.json')
firebase_admin.initialize_app(cred)
db = firestore.client()
app = Flask(__name__)

# FUNCTIONS
def validateEmail(email):
  result = re.match("[^@]+@[^@]+\.[A-Za-z0-9]+$", email)
  if result:
    return True
  else:
    return False


@app.route("/")
def home():
  return "I am UP :)"

# USER SIGN UP
@app.route("/api/user_signup")
def userSignup():
  username = request.args.get('username')
  email = request.args.get('email')
  isVerified = False
  imageurl = None

  if (username != None and email != None):
    if (username != "" and email != ""):
      if validateEmail(email):
        docs = db.collection("userinfo").where("email", "==", email).get()
        if len(docs) == 0:
          db.collection("userinfo").document().set({
            "username": username, 
            "email": email, 
            "imageurl": imageurl, 
            "level": 0,
            "isVerified": isVerified,
            })

          return "Success"

  return "Failed"


# ORGANIZER SIGN UP
@app.route("/api/organizer_signup")
def organizerSignup():
  username = request.args.get('username')
  email = request.args.get('email')
  print(email)
  imageurl = None
  special = False
  amountGiven = 0
  rating = 0.0

  # check for validations...

  if (username != None and email != None):
    if (username != "" and email != ""):
      if validateEmail(email):
        usercheck = db.collection("userinfo").where("email", "==", email).get()
        if len(usercheck) == 0:
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
  
  # create a separate table of users who are registered for that match

  if (matchuid != None and useruid != None):

    # checking whether user is verified (KYC)
    user = db.collection("userinfo").document(useruid).get()
    userdata = user.to_dict()
    if userdata == None:
      return "Failed: No such user"
    if userdata["isVerified"] == False:
      return "Failed: User not verified"
    

    # checking for already registered..
    user = db.collection("userinfo").document(useruid).collection("registered").get()
    user = [user.id for user in user]
    if matchuid in user:
      return "Failed: Already registered"

    # if all conditions passed, then check for valid matchuid
    ref = db.collection("pubg").document(matchuid)
    ref_obj = ref.get().to_dict()
    try:
      date = ref_obj["date"]
      matchType = "pubg"
      uid = matchuid
      name = ref_obj["name"]
    except:
      return "Failed: No such match"

    # retrieve the total registered and increase it by one [USE TRANSACTION!]
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
      db.collection("userinfo").document(useruid).collection("registered").document(matchuid).set({"date": date, "matchType": matchType, "name": name, "uid": uid})
      return "Success"
    else:
      return "Failed"

  return "Failed"

# CREATE MATCHES
@app.route("/api/create")

# date, fee, match, name, skill, solo, reg=0, special, uid
def create():
  date = request.args.get("date")
  fee = request.args.get("fee", type=int)
  match = request.args.get("match", type=bool)
  name = request.args.get("name", type=str)
  skill = request.args.get("skill", type=int)
  solo = request.args.get("solo", type=int)
  uid = request.args.get("uid", type=str)

  # validations.....
  # check if the organizer is special and add accordingly
  # check if the uid is valid
  # check if the organizer is eligible to organize high end matches
  # 

  # converting date from string to datetime object
  try:
    date = datetime.strptime(date, '%Y-%m-%d %H:%M:%S.%f')
    print(date)
    date.replace(hour=0, minute=0, second=0, microsecond=0)
    print(datetime.now())

    # checking if date is valid
    if date < datetime.now():
      return "Failed"
    
    # checking if date is atleast two days from now
    if date.day < (datetime.now().day + 2):
      return "Failed"
  except:
    return "Failed"

  # checking if organizer uid is valid
  organizerData = db.collection("organizer").document(uid).get()
  organizerData = organizerData.to_dict()
  if organizerData == None:
    return "Failed"
  
  # gathering special status
  special = organizerData["special"]

    

  db.collection("pubg").document().set({
    "date": date,
    "fee": fee,
    "match": match,
    "name": name,
    "skill": skill,
    "solo": solo,
    "uid": uid,
    "special": special,
    "reg": 0
  })

  return "Hi :)"



app.run(debug=True)
