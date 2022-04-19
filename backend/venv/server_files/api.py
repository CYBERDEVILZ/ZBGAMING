"""
OPTIMIZATIONS / IDEAS
---------------------

IMPORTANT!!!
ORGANIZER UPDATED FINISHED STATUS AND WHO WON THE MATCH. VALIDATORS VALIDATE WHETHER THE WINNER IS LEGIT.
IF MATCH IS NOT 'ONGOING' EVEN AFTER THE DATE HAS PASSED, AUTOMATICALLY THE MATCH WILL BE FINISHED AND 
MONEY WILL BE REFUNDED TO ALL.

CALL CLEAN API EVERYTIME THE USER VISITS ANY MATCH SECTION OR REGISTERED SECTION

ORGANIZER GETS A LIST OF PEOPLE WHO REGISTERED FOR HIS MATCH. THEIR UNIQUE ID IS THEIR EMAIL. NEVER EXPOSE UID!
HE SELECTS WHO WON THE MATCH WHEN HE FINISHES THE MATCH. HE UPDATES IT AND THEN READ POINT ONE.

Organizer starts the match if eligible, further registration stops, ongoing message shown. If finished, finished message shown
Validator should be able to validate a match
Validate organizers (KYC, BANK ACCOUNT, isverified tag add if they are verified)
Database Cleanup (After every call to view matches, registered matches, always clean the database)
Backend to calculate organizer ratings
Backend to calculate user, organizer levels
Backend to collect and distribute money
Organizer account delete
Customer Care chat feature, account related assistance, monetary related assistance
Add report functionality

AFTER MATCH GETS OVER, ORGANIZER UPDATES WHO WON AND VALIDATOR CHECKS THE UPDATION
OPTIMIZE LEVEL CALCULATION (RIGHT NOW IT IS LINEAR :/ )
"""


from datetime import datetime, timedelta
from flask import Flask
from flask import request
import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore
import razorpay
import re

# FIREBASE INIT
cred = credentials.Certificate("zbgaming-v1-firebase-adminsdk-2ozhj-4f38e5fc3e.json")
firebase_admin.initialize_app(cred)
db = firestore.client()
app = Flask(__name__)

# RAZORPAY INIT
secret_key = "C7IHXyYq0nsDlWQYUcRKGzaH"
client = razorpay.Client(auth=("rzp_test_rKi9TFV4sMHvz2", secret_key))

# FUNCTIONS
def validateEmail(email):
    result = re.match("[^@]+@[^@]+\.[A-Za-z0-9]+$", email)
    if result:
        return True
    else:
        return False


# HOME
@app.route("/")
def home():
    return "I am UP :)"


# USER SIGN UP
@app.route("/api/user_signup")
def userSignup():
    username = request.args.get("username")
    email = request.args.get("email")
    docId = request.args.get("docId")
    isVerified = False
    imageurl = None

    if username != None and email != None and docId != None:
        if username != "" and email != "" and docId != "":
            if validateEmail(email):
                docs = db.collection("userinfo").where("email", "==", email).get()
                if len(docs) == 0:
                    docs = db.collection("organizer").where("email", "==", email).get()
                    if len(docs) == 0:
                        db.collection("userinfo").document(docId).set(
                            {
                                "username": username,
                                "email": email,
                                "imageurl": imageurl,
                                "level": 0,
                                "isVerified": isVerified,
                            }
                        )

                        return "Success"

    return "Failed"


# ORGANIZER SIGN UP
@app.route("/api/organizer_signup")
def organizerSignup():
    username = request.args.get("username")
    email = request.args.get("email")
    docId = request.args.get("docId")
    print(email)
    imageurl = None
    special = False
    amountGiven = 0
    rating = 0.0

    # check for validations...

    if username != None and email != None and docId != None:
        if username != "" and email != "" and docId != "":
            if validateEmail(email):
                usercheck = db.collection("userinfo").where("email", "==", email).get()
                if len(usercheck) == 0:
                    docs = db.collection("organizer").where("email", "==", email).get()
                    if len(docs) == 0:
                        db.collection("organizer").document(docId).set(
                            {
                                "username": username,
                                "email": email,
                                "imageurl": imageurl,
                                "special": special,
                                "amountGiven": amountGiven,
                                "rating": rating,
                            }
                        )
                        return "Success"

    return "Failed"


# REGISTER 
@app.route("/api/register")
def register():
    matchType = request.args.get("matchType")
    matchuid = request.args.get("matchuid")
    useruid = request.args.get("useruid")

    if matchuid != None and useruid != None and matchType != None:
        if matchType.lower() == "pubg":

            # checking whether user is verified (KYC)
            user = db.collection("userinfo").document(useruid).get()
            userdata = user.to_dict()
            if userdata == None:
                return "Failed: No such user"
            if userdata["isVerified"] == False:
                return "Failed: User not verified"

            # checking if matchuid exists
            matchData = db.collection(matchType.lower()).document(matchuid).get()
            matchData = matchData.to_dict()
            if matchData == None:
                return "Failed: Match Doesn't Exist"

            # checking for already registered..
            user = (
                db.collection("userinfo").document(useruid).collection("registered").get()
            )
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
                paid = ref_obj["fee"]
                skill = ref_obj["skill"]
                started = ref_obj["started"]
            except:
                return "Failed: No such match"
            
            if paid != 0:
                return "Failed: Can't register for free"

            if started != 0:
                return "Failed: This match is no longer accepting registration"
            

            # retrieve the total registered and increase it by one [USE TRANSACTION!]
            transaction = db.transaction()

            @firestore.transactional
            def updateRegisteredTeams(transaction, ref):
                snapshot = ref.get(transaction=transaction)
                reg = snapshot.get("reg")
                total = snapshot.get("total")
                try:
                    if reg < total:
                        transaction.update(ref, {"reg": reg + 1})
                        return True
                    else:
                        return False
                except:
                    return False

            result = updateRegisteredTeams(transaction, ref)

            if result:
                
                # add to registered
                db.collection("userinfo").document(useruid).collection(
                    "registered"
                ).document(matchuid).set(
                    {"date": date, "matchType": matchType, "name": name, "uid": uid}
                )

                # add to history
                db.collection("userinfo").document(useruid).collection("history").document(
                    matchuid
                ).set({"date": date, "matchType": matchType, "name": name, "uid": uid, "paid": paid, "won": 0, "skill": skill})
                return "Success"
            else:
                return "Failed"
        else: 
            return "Failed"

    return "Failed"


# CREATE ORDER
# Only creates order for the client  
@app.route("/api/createOrder")
def paidRegister():
    matchType = request.args.get("matchType")
    matchuid = request.args.get("matchuid")
    useruid = request.args.get("useruid")

    if matchuid != None and useruid != None and matchType != None:
        amount = None
        if matchType.lower() == "pubg":

            # checking whether user is verified (KYC)
            user = db.collection("userinfo").document(useruid).get()
            userdata = user.to_dict()
            if userdata == None:
                return "Failed: No such user"
            if userdata["isVerified"] == False:
                return "Failed: User not verified"

            # checking if matchuid exists
            matchData = db.collection(matchType.lower()).document(matchuid).get()
            matchData = matchData.to_dict()
            if matchData == None:
                return "Failed: Match Doesn't Exist"

            # checking for already registered..
            user = (
                db.collection("userinfo").document(useruid).collection("registered").get()
            )
            user = [user.id for user in user]
            if matchuid in user:
                return "Failed: Already registered"

            # if all conditions passed, then check for valid matchuid
            ref = db.collection("pubg").document(matchuid)
            ref_obj = ref.get().to_dict()
            try:
                matchType = "pubg"
                paid = ref_obj["fee"]
            except:
                return "Failed: No such match"
            
            if paid == 1:
                amount = 100 * 100
            elif paid == 2:
                amount == 500 * 100
            elif paid == 3:
                amount = 1000 * 100
            elif paid == 4:
                amount = 2000 * 100
            else:
                return "Failed: Price mismatch"

            DATA = {
                "amount": amount,
                "currency": "INR",
            }

            # CREATING ORDER
            response = client.order.create(data=DATA)
            order_id = response["id"]

            # RETURNING ORDER FOR CHECKOUT
            return order_id
            
        else: 
            return "Failed"

    return "Failed" 


# ORDER VALIDATION AND PAID REGISTRATION
@app.route("/api/validateOrder")
def validate():
    order_id = request.args.get("order_id")
    razorpay_signature = request.args.get("razorpay_signature")
    razorpay_payment_id = request.args.get("razorpay_payment_id")
    matchType = request.args.get("matchType")
    matchuid = request.args.get("matchuid")
    useruid = request.args.get("useruid")

    verifyStatus = client.utility.verify_payment_signature({
   'razorpay_order_id': order_id,
   'razorpay_payment_id': razorpay_payment_id,
   'razorpay_signature': razorpay_signature
   })

    if verifyStatus:
        if matchuid != None and useruid != None and matchType != None:
            if matchType.lower() == "pubg":

                # checking whether user is verified (KYC)
                user = db.collection("userinfo").document(useruid).get()
                userdata = user.to_dict()
                if userdata == None:
                    return "Failed: No such user"
                if userdata["isVerified"] == False:
                    return "Failed: User not verified"

                # checking if matchuid exists
                matchData = db.collection(matchType.lower()).document(matchuid).get()
                matchData = matchData.to_dict()
                if matchData == None:
                    return "Failed: Match Doesn't Exist"

                # checking for already registered..
                user = (
                    db.collection("userinfo").document(useruid).collection("registered").get()
                )
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
                    paid = ref_obj["fee"]
                    skill = ref_obj["skill"]
                except:
                    return "Failed: No such match"
                
                # retrieve the total registered and increase it by one [USE TRANSACTION!]
                transaction = db.transaction()

                @firestore.transactional
                def updateRegisteredTeams(transaction, ref):
                    snapshot = ref.get(transaction=transaction)
                    reg = snapshot.get("reg")
                    total = snapshot.get("total")
                    try:
                        if reg < total:
                            transaction.update(ref, {"reg": reg + 1})
                            return True
                        else:
                            return False
                    except:
                        return False

                result = updateRegisteredTeams(transaction, ref)

                if result:
                    
                    # add to registered
                    db.collection("userinfo").document(useruid).collection(
                        "registered"
                    ).document(matchuid).set(
                        {"date": date, "matchType": matchType, "name": name, "uid": uid}
                    )

                    # add to history
                    db.collection("userinfo").document(useruid).collection("history").document(
                        matchuid
                    ).set({"date": date, "matchType": matchType, "name": name, "uid": uid, "paid": paid, "won": 0, "skill": skill})
                    return "Registration Successful!"
                else:
                    return "Failed"
            else: 
                return "Failed"

        return "Failed"

    else:
        return "Something went wrong"
        


    


# CREATE MATCHES
@app.route("/api/create")
# date, fee, match, name, skill, solo, reg=0, special, uid
def create():
    date = request.args.get("date")
    uid = request.args.get("uid")
    fee = request.args.get("fee")
    match = request.args.get("match")
    name = request.args.get("name")
    skill = request.args.get("skill")
    solo = request.args.get("solo")
    matchType = request.args.get("matchType")
    started = 0
    total = 0

    if matchType.lower() == "pubg":
        total = 100

        # validating data types
        try:
            fee = int(fee)
            skill = int(skill)
        except:
            return "Failed"
        if fee > 4 or fee < 0:
            return "Failed"
        if skill > 2 or skill < 0:
            return "Failed"
        if match.lower() == "true":
            match = True
        elif match.lower() == "false":
            match = False
        else:
            return "Failed"
        if solo.lower() == "true":
            solo = True
        elif solo.lower() == "false":
            solo = False
        else:
            return "Failed"

        # converting date from string to datetime object
        try:
            date = datetime.strptime(date, "%Y-%m-%d %H:%M:%S.%f")
            date = date.replace(hour=0, minute=0, second=0, microsecond=0)

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

        # checking match creation eligibility
        if not special:
            if fee == 3 or fee == 4:
                return "Failed"

        db.collection(matchType.lower()).document().set(
            {
                "date": date,
                "fee": fee,
                "match": match,
                "name": name,
                "skill": skill,
                "solo": solo,
                "uid": uid,
                "special": special,
                "reg": 0,
                "total": total,
                "started": started,
            }
        )

        return "Success"
    else:
        return "Failed"


# API TO CLEAN DATABASE
@app.route("/api/clean")
def clean():
    matchType = request.args.get("matchType")
    uid = request.args.get("uid")  # uid of user (to delete registered game)

    if matchType != None and uid != None:
        if matchType != "" and uid != "":
            date = datetime.now() - timedelta(days=1)
            print(date)

            # get all the outdated matches
            docs = db.collection(matchType).where("date", "<", date).get()

            # delete all the outdated matches
            for doc in docs:
                db.collection(matchType).document(doc.id).delete()
                db.collection("userinfo").document(uid).collection(
                    "registered"
                ).document(doc.id).delete()

            return "Success"

    return "Failed"

# VERIFY USER
@app.route("/api/verify/user")
def verifyUser():
    verifierID = request.args.get("vid")
    userID = request.args.get("uid")

    if verifierID != None and userID != None:
        if verifierID != "" and userID != "":
            
            # verifying verifier ID
            verifierData = db.collection("verifier").document(verifierID).get().to_dict()
            if verifierData == None:
                return "Failed"
            
            # verifying user ID
            userdata = db.collection("userinfo").document(userID).get().to_dict()
            if userdata == None:
                return "Failed"
            
            # If all checks out to be good
            try:
                db.collection("userinfo").document(userID).update({"isVerified": True})
                return "Success"
            except:
                return "Failed"

    return "Failed"

# VALIDATOR SIGNUP
@app.route("/api/verifier/thiswillmakefindingthisapidifficult/signup")
def verifierSignup():
    username = request.args.get("username")
    email = request.args.get("email")

    if username != None and email != None:
        if username != "" and email != "":
            if validateEmail(email):
                docs = db.collection("verifier").where("email", "==", email).get()
                if len(docs) == 0:
                    db.collection("verifier").document().set(
                        {
                            "username": username,
                            "email": email,
                        }
                    )

                    return "Success"

    return "Failed"

# USER LEVEL CALCULATION
@app.route("/api/userlevelcalculate")
def userLevelCalculate():
    participation = 0
    won = 0
    uid = request.args.get("uid")

    # Checking if uid is valid
    try:
        # get all the paid matches
        docs = db.collection("userinfo").document(uid).collection("history").where("paid", "!=", 0).get()

        # no matches played yet, make level 0
        if len(docs) == 0:
            db.collection("userinfo").document(uid).update({"level": 0})
            return "Success"
        
        participation = len(docs) * 20

        # calculate the level of user
        for doc in docs:
            data = doc.to_dict()
            wonMatches = data["won"]
            
            if wonMatches == 1:
                paid = data["paid"]
                # scores based on FEE STRUCTURE
                if paid == 1:
                    won += 300
                if paid == 2:
                    won += 500
                if paid == 3:
                    won += 1500
                if paid == 4:
                    won += 2000
                else:
                     won += 0
        
        totalScore = participation + won
        db.collection("userinfo").document(uid).update({"level": totalScore})
        return "Success"
        
    except:
        return "Failed"



    

app.run(debug=True)
