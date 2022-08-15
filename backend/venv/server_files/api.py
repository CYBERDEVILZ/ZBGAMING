"""
OPTIMIZATIONS / IDEAS
---------------------

########################## LOGIC SECTION ###############################

EVEN AFTER STOPPING A MATCH, THERE IS AN OPTION TO CANCEL MATCH. THIS SHOULD NOT BE MADE AVAILABLE

DEPENDING ON THE NUMBER OF USERS AND THE TYPE OF MATCH,  THE TOTAL AMOUNT SHOULD BE CALCULATED AUTOMATICALLY AND 
UPDATED IN THE MATCH DATABASE.

WHEN THE MATCH IS STOPPED, GRAB THE TOTAL AMOUNT FROM GAME DATABASE, 60% OF IT AND ADD IT TO HISTORY OF WINNER.

UPDATE AMOUNT GIVEN PARAMETER WHEN THE ORGANIZER SUCCESSFULLY ORGANIZE A MATCH THAT IS PAID.

CREATE CLOUD FUNCTIONS THAT ACTS ON TRIGGER (WHEN ORGANIZER STOPS THE MATCH) TO UPDATE THE LEVEL OF EACH USER

INSANE SECURITY ISSUE!!!
------------------------
START MATCH, STOP MATCH, CANCEL MATCH, ETC ARE NOT PROTECTED FROM CSRF! MAKE SURE TO AUTHENTICATE THE SOURCE OF REQUEST!

IMPORTANT!!!
ADD SEARCH USER FEATURE TO LOOK FOR PLAYERS BY OTHER USERS

IMPORTANT!!!
UNIQUE ID FOR PLAYERS --  FIREBASE UID (SECRET) => SHA256 HASH => BLOB (BYTE STRING) [0XFD0XFA0XAE -- fdfaae]

IMPORTANT!!!
POLICY NOT ADDED FOR ORGANIZER SIGNUP

IMPORTANT!!!
CREATE BACKEND TO CALCULATE ORGANIZER LEVEL BASED ON AMOUNTGIVEN PARAMETER.

IMPORTANT!!!
I HAVE USED TOKENS FOR PUSH NOTIFICATION. CONVERT THEM INTO TOPICS FOR FASTER SENDING. OR USE BACKGROUND WORKER (LEAST PREFERRED)

IMPORTANT!!!
VALIDATE ORGANIZER SIGNIN AS WELL. NORMAL PLAYERS CAN ALSO SIGN IN AS ORGANIZERS AND THERE IS A BUG!

IMPORTANT!!!
ORGANIZER VERIFICATION
IN ORDER TO CREATE MATCHES, THE ORGANIZER SHOULD BE VERIFIED (KYC).

IMPORTANT!!!
CREATE LOGIC FOR PAYOUTS

IMPORTANT!!!
USER KYC VERIFICATION PAGE LEFT

Organizer account delete


########################## DESIGN SECTION ###############################

IMPORTANT!!!
UPDATE RULES IN CONTEST DETAILS PAGE. THEY ARE OUTDATED

IMPORTANT!!!
I HAVE ADDED TWO NEW IMAGES: ZBUNKER BANNER SHORT AND ZBUNKER BANNER UPSIDE DOWN SHORT. MAKE SURE TO REPLACE THE ORIGINAL WITH SHORT AND 
CHECK THE RESULT. REALLY IMPORTANT TO REDUCE SIZE!

IMPORTANT!!!
CREATE FRONTEND FOR ORGANIZER VERIFIED. JUST ADD VERIFY ME TAGS LIKE THAT OF USER VERIFICATION


###################### FEATURES FOR FUTURE DEVS ##############################

OPTIMIZE USER LEVEL CALCULATION AS WELL AS ORGANIZER LEVEL CALCULATION (IF EXISTS)

ORGANIZER PAGE WHERE HE CAN UPLOAD POSTS AND SCORECARDS


"""


from datetime import datetime
import json
from flask import Flask
from flask import request
import firebase_admin
from firebase_admin import credentials, messaging
from firebase_admin import firestore
from pytz import timezone
import pytz
import razorpay
import re
import hashlib
import requests
from apscheduler.schedulers.background import BackgroundScheduler


games = ["pubg"]

# FIREBASE INIT
cred = credentials.Certificate("zbgaming-v1-firebase-adminsdk-2ozhj-4f38e5fc3e.json")
firebase_admin.initialize_app(cred)
db = firestore.client()
app = Flask(__name__)

REST_API_VERIFY_EMAIL = "https://identitytoolkit.googleapis.com/v1/accounts:sendOobCode?key=AIzaSyApP0fP9W-HngWhu-qtEqJtzHE4EHMTaFw"

# RAZORPAY INIT
secret_key = "C7IHXyYq0nsDlWQYUcRKGzaH"
client = razorpay.Client(auth=("rzp_test_rKi9TFV4sMHvz2", secret_key))

# FUNCTIONS
# email validation
def validateEmail(email):
    result = re.match("[^@]+@[^@]+\.[A-Za-z0-9]+$", email)
    if result:
        return True
    else:
        return False

# refund money logic
def refund():
    print("refund all the money BLYAT! and Give organizer bad rating!")

# delete game from database
def deleteGame(game, gameID):
    docs1 = db.collection(game).document(gameID).collection("registeredUsers").get()
    for doc in docs1:
        doc.reference.delete()
    db.collection(game).document(gameID).delete()

# delete chats
def deleteChat(chatID):
    db.collection("chats").where("notificationId", "==", chatID).get()[0].reference.delete()

# update history of users to cancelled
def updateHistoryToCancelled(game, gameID):
    docs1 = db.collection(game).document(gameID).collection("registeredUsers").get()
    for doc in docs1:
        doc_data = doc.to_dict()
        hashedID = doc_data["hashedID"]
        users = db.collection("userinfo").where("hashedID", "==", hashedID).get()
        for user in users:
            print(user.id)
            user.reference.collection("history").document(gameID).update({"won": 2})


# BACKGROUND SCHEDULERS
scheduler = BackgroundScheduler()
# SCHEDULE 1: look for matches that are over. Perform necessary actions
def schedule_1_are_matches_over():
    for game in games:
        date_over_matches = db.collection(game).where("date", "<", datetime.now()).get()
        for matches in date_over_matches:
            match_data = matches.to_dict()
            if (match_data["started"] == 0):
                print("match was never started! lets refund all the money and show it cancelled")
                refund()
                deleteChat(match_data["notificationId"])
                updateHistoryToCancelled(game, matches.id)
                deleteGame(game, matches.id)
            if (match_data["started"] == 1):
                db.collection()
                print("match started but not stopped. lets refund all the money and show it cancelled")
                refund()
                deleteChat(match_data["notificationId"])
                updateHistoryToCancelled(game, matches.id)
                deleteGame(game, matches.id)
            if (match_data["started"] == 2):
                print("match was stopped. Nice organizer. Give him a hug")
                deleteGame(game, matches.id)
                deleteChat(match_data["notificationId"])
        print("scheduler running -------------------")
                
# run every 24 hours
job = scheduler.add_job(schedule_1_are_matches_over, "interval", seconds=10)
scheduler.start()

            


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
    idToken = request.args.get("idToken")
    isVerified = False
    imageurl = None

    if username != None and email != None and docId != None:
        if username != "" and email != "" and docId != "":
            username = username.lower()
            if validateEmail(email):
                docs = db.collection("userinfo").where("email", "==", email).get()
                if len(docs) == 0:
                    docs = db.collection("organizer").where("email", "==", email).get()
                    if len(docs) == 0:

                        # sending email verification link
                        data = json.dumps({
                            "requestType": "VERIFY_EMAIL",
                            "idToken": idToken
                        })
                        r = requests.post(url=REST_API_VERIFY_EMAIL, data=data)
                        if r.status_code != 200:
                            return "Failed"
                        
                        # username must be unique
                        if(len(db.collection("userinfo").where("username", "==", username).get()) != 0):
                            return "Failed: Username is already taken"

                        # sending data to cloud firestore
                        db.collection("userinfo").document(docId).set(
                            {
                                "username": username,
                                "email": email,
                                "imageurl": imageurl,
                                "level": 0,
                                "isVerified": isVerified,
                                "hashedID": hashlib.sha256(docId.encode()).digest()
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
    token = request.args.get("token")

    if matchuid != None and useruid != None and matchType != None and token != None:
        if matchType.lower() == "pubg":

            # checking whether user is verified (KYC)
            user = db.collection("userinfo").document(useruid).get()
            userdata = user.to_dict()
            if userdata == None:
                return "Failed: No such user"
            if userdata["isVerified"] == False:
                return "Failed: User not verified"

            # checking whether the user has linked his game account
            ids = db.collection("userinfo").document(useruid).collection("linkedAccounts").document("Player Unknown Battlegrounds").get()
            ids_dict = ids.to_dict()
            if ids_dict == None:
                return "Failed: Account not linked"
            if ids_dict["id"] == None or ids_dict["id"] == "":
                return "Failed: Account not linked"
            

            # checking for already registered on user side..
            registeredMatches = (
                db.collection("userinfo").document(useruid).collection("registered").get()
            )
            matchId = [match.id for match in registeredMatches]
            if matchuid in matchId:
                return "Failed: Already registered"
            isHeRegistered = db.collection(matchType.lower()).document(matchuid).collection("registeredUsers").where("hashedID", "==", hashlib.sha256(useruid.encode()).digest()).get()
            if len(isHeRegistered) != 0:
                return "Failed: Already registered"

            # checking if matchuid exists
            ref = db.collection("pubg").document(matchuid)
            ref_obj = ref.get().to_dict()
            if ref_obj == None:
                return "Failed: Match Doesn't Exist"

            date = ref_obj["date"]
            matchType = "pubg"
            uid = matchuid
            name = ref_obj["name"]
            paid = ref_obj["fee"]
            skill = ref_obj["skill"]
            started = ref_obj["started"]
            notifId = ref_obj["notificationId"]
            
            if paid != 0:
                return "Failed: Can't register for free"

            if started != 0:
                return "Failed: This match is no longer accepting registration"
            
            if userdata["level"] < skill:
                return "Failed: Don't have enough skill"
            

            # retrieve the total registered and increase it by one [USE TRANSACTION!]
            transaction = db.transaction()

            @firestore.transactional
            def updateRegisteredTeams(transaction, ref):
                snapshot = ref.get(transaction=transaction)
                reg = snapshot.get("reg")
                total = snapshot.get("total")
                try:
                    if reg < total:
                        transaction.update(ref, {"reg": reg + 1, "userMessageTokens": firestore.ArrayUnion([token])})
                        return True
                    else:
                        return False
                except:
                    return False

            result = updateRegisteredTeams(transaction, ref)

            if result:

                # add to match's registration list
                ref.collection("registeredUsers").document().set({
                    "email": userdata["email"],
                    "username": userdata["username"],
                    "IGID": ids_dict["id"],
                    "hashedID": hashlib.sha256(useruid.encode()).digest()
                })
                
                # add to registered
                db.collection("userinfo").document(useruid).collection(
                    "registered"
                ).document(matchuid).set({
                    "date": date, 
                    "matchType": matchType,
                    "name": name,
                    "uid": uid,
                    "notificationId": notifId,
                    "hasRated": False
                    })

                # add to history
                db.collection("userinfo").document(useruid).collection("history").document(
                    matchuid
                ).set({"date": date, "matchType": matchType, "name": name, "uid": uid, "paid": paid, "won": -1, "skill": skill, "amount": 0})

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
    token = request.args.get("token")

    if matchuid != None and useruid != None and matchType != None and token != None:
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

             # checking whether the user has linked his game account
            ids = db.collection("userinfo").document(useruid).collection("linkedAccounts").document("Player Unknown Battlegrounds").get()
            ids_dict = ids.to_dict()
            if ids_dict == None:
                return "Failed: Account not linked"
            if ids_dict["id"] == None or ids_dict["id"] == "":
                return "Failed: Account not linked"

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
                amount = 500 * 100
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

            # for notification room
            secret_key = "shinra_tensei"
            datething = str(datetime.now())
            toHash = matchuid+secret_key+datething
            hashedValue = hashlib.sha256(toHash.encode()).digest()

            db.collection("chats").document().set({
                "notificationId": hashedValue,
                "chats": [{"message": "Thank You all for joining this match!", "time": datetime.now(timezone(zone="Asia/Kolkata"))}]
            })

            # RETURNING ORDER FOR CHECKOUT
            return order_id
            
        else: 
            return "Failed: matchType doesn't exist"

    return "Failed: Request parameters missing" 


# ORDER VALIDATION AND PAID REGISTRATION
@app.route("/api/validateOrder")
def validate():
    order_id = request.args.get("order_id")
    razorpay_signature = request.args.get("razorpay_signature")
    razorpay_payment_id = request.args.get("razorpay_payment_id")
    matchType = request.args.get("matchType")
    matchuid = request.args.get("matchuid")
    useruid = request.args.get("useruid")
    token = request.args.get("token")

    verifyStatus = client.utility.verify_payment_signature({
   'razorpay_order_id': order_id,
   'razorpay_payment_id': razorpay_payment_id,
   'razorpay_signature': razorpay_signature
   })

    if verifyStatus:
        if matchuid != None and useruid != None and matchType != None and token!=None:
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

                # checking whether the user has linked his game account
                ids = db.collection("userinfo").document(useruid).collection("linkedAccounts").document("Player Unknown Battlegrounds").get()
                ids_dict = ids.to_dict()
                if ids_dict == None:
                    return "Failed: Account not linked"
                if ids_dict["id"] == None or ids_dict["id"] == "":
                    return "Failed: Account not linked"

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
                    notifId = ref_obj["notificationId"]
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
                            transaction.update(ref, {"reg": reg + 1, "userMessageTokens": firestore.ArrayUnion([token])})
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
                    ).document(matchuid).set({
                        "date": date,
                        "matchType": matchType, 
                        "name": name, 
                        "uid": uid, 
                        "notificationId": notifId, 
                        "hasRated": False
                    })

                    # add to match's registration list
                    ref.collection("registeredUsers").document().set({
                        "email": userdata["email"],
                        "username": userdata["username"],
                        "IGID": ids_dict["id"],
                        "hashedID": hashlib.sha256(useruid.encode()).digest()
                    })

                    # add to history
                    db.collection("userinfo").document(useruid).collection("history").document(
                        matchuid
                    ).set({"date": date, "matchType": matchType, "name": name, "uid": uid, "paid": paid, "won": -1, "skill": skill, "amount": 0})


                    return "Success"
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
            date = date.replace(hour=23, minute=59, second=59, microsecond=0)
            local = pytz.timezone("Asia/Kolkata")
            current_date_in_utc = local.localize(datetime.now(), is_dst=None).astimezone(pytz.utc)
            local_dt = local.localize(date, is_dst=None)
            date = local_dt.astimezone(pytz.utc)

            # checking if date is valid
            if date < current_date_in_utc:
                return "Failed: Invalid Date"

            # checking if date is atleast two days from now
            if date.day < (current_date_in_utc.day + 1):
                return "Failed: Cannot choose this date"
        except:
            return "Failed: Server Error"

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

        # for notification room
        secret_key = "shinra_tensei"
        datething = str(datetime.now())
        toHash = uid+secret_key+datething
        hashedValue = hashlib.sha256(toHash.encode()).digest()
        if fee != 0:
            paid = True
        else:
            paid = False

        db.collection(matchType.lower()).document().set(
            {
                "date": date,
                "fee": fee,
                "match": match,
                "name": name,
                "paid": paid,
                "skill": skill,
                "solo": solo,
                "uid": uid,
                "special": special,
                "reg": 0,
                "total": total,
                "started": started,
                "notificationId": hashedValue
            }
        )

        db.collection("chats").document().set({
            "notificationId": hashedValue,
            "chats": [{"message": "Thank You all for joining this match!", "time": datetime.now(timezone(zone="Asia/Kolkata"))}]
        })

        return "Success"
    else:
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


# USER LEVEL CALCULATION
@app.route("/api/userlevelcalculatealternative")
def userLevelCalculateAlternative():
    participation = 0
    won = 0
    uid = request.args.get("uid")

    # Checking if uid is valid
    try:

        docs = db.collection("userinfo").where("tempUid", "==", uid).get()
        if len(docs) != 1:
            return "Failed"
            
        docId = docs[0].id

        # get all the paid matches
        docs = db.collection("userinfo").document(docId).collection("history").where("paid", "!=", 0).get()

        # no matches played yet, make level 0
        if len(docs) == 0:
            db.collection("userinfo").document(docId).update({"level": 0})
            return "Success"
        
        participation = len(docs) * 20
        amount = 0

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

        # update score
        db.collection("userinfo").document(docId).update({"level": totalScore})

        return "Success"
        
    except:
        return "Failed"

# START MATCH LOGIC
@app.route("/api/startMatch")
def startMatch():
    matchUid = request.args.get('muid')
    matchType = request.args.get("mType")
    streamLink = request.args.get('streamLink')
    matchType = matchType.lower()


    if streamLink == None:
        return "Failed: Invalid URL"

    streamLink = streamLink.strip()

    if streamLink == "":
        return "Failed: Invalid URL"

    try:
        data = db.collection(matchType).document(matchUid).get().to_dict()
        if data == None:
            return "Failed: No such match"
        
        if data["started"] != 0:
            return "Failed: Match cannot be started"
        if data["reg"] < 2:
            return "Failed: Not enough registrations"
            
        userMessageTokens = data["userMessageTokens"]
        name = data["name"]
        for token in userMessageTokens:
            try:
                message = messaging.Message(notification=messaging.Notification(title="Are You Ready for the Battle?", body=f"Your registered match '{name}' will begin in a few minutes! Visit the chat room to know more!"), token=token, data={"route": "/registeredMatches"})
                messaging.send(message)
            except BaseException as err:
                print(f"an error occurred: {err}")
                pass
        db.collection(matchType).document(matchUid).update({
            "started": 1,
            "streamLink": streamLink
        })
        return "Success"
    except:
        return "Failed: Something went wrong"

# STOP MATCH LOGIC
@app.route("/api/stopMatch")
def stopMatch():
    matchUid = request.args.get('muid')
    matchType = request.args.get("mType")
    matchType = matchType.lower()

    try:
        data = db.collection(matchType).document(matchUid).get().to_dict()
        if data == None:
            return "Failed"
        if data["started"] != 1:
            return "Failed: Something went wrong"
        if data["notificationId"] == None:
            return "Failed: Something went wrong"
        notifId = data["notificationId"]

        # delete chat section logic
        chat = db.collection("chats").where("notificationId", "==", notifId).get()
        try:
            chat_id = chat[0].id
            db.collection("chats").document(chat_id).delete()
        except:
            pass

        db.collection(matchType).document(matchUid).update({
            "started": 2
        })

        userMessageTokens = data["userMessageTokens"]
        name = data["name"]
        for token in userMessageTokens:
            try:
                message = messaging.Message(notification=messaging.Notification(title="Match ended", body=f"Your registered match '{name}' has ended. Congratulations to the winner!"), token=token, data={"routename": "contest-details", "matchuid": matchUid, "matchtype": matchType.lower()})
                messaging.send(message)
            except:
                pass
        return "Success"
    except:
        return "Failed"

# NOTIFICATION WHEN ORGANIZER SENDS MESSAGE
@app.route("/api/receivedNotification")
def receivedNotification():
    muid = request.args.get("muid")
    mtype = request.args.get("mtype")
    
    if muid != None and mtype != None:
        mtype = mtype.lower()
        data = db.collection(mtype).document(muid).get().to_dict()
        if data == None:
            return "Failed"
        userMessageTokens = data["userMessageTokens"]
        name = data["name"]
        for token in userMessageTokens:
            try:
                message = messaging.Message(notification=messaging.Notification(title="You received a new message!", body=f"Organizers of '{name}' has sent you a message. Quickly check it out!"), token=token,data={"route": "/registeredMatches"})
                messaging.send(message)
            except:
                pass
        return "Success"
    
    return "success"
        

@app.get("/api/reportMatch")
def reportMatch():
    muid = request.args.get("muid")
    mtype = request.args.get("mtype")
    uuid = request.args.get("uuid")
    rtype = request.args.get("rtype")
    reportData = request.args.get("otherReport")

    reportArray = [
        "Match was started early without prior notice",
        "Player(s) was/were found cheating", 
        "Organizer selected the wrong winner", 
        "No information regarding the match was shared by the organizer in the Chat Section"
        ]
    
    try:
        rtype = int(rtype)
        if rtype < 0 or rtype > 4:
            return "Failed"
        if rtype < 4:
            reportData = reportArray[rtype]

    except:
        return "Failed"

    if muid == None and uuid == None and mtype == None and rtype == None:
        return "Failed"
    
    if muid == "" and uuid == "" and mtype == "" and rtype == "":
        return "Failed"
    
    uuid = hashlib.sha256(uuid.encode()).digest()

    if mtype.lower() not in games:
        return "Failed: Invalid Game"
    
    matchData = db.collection(mtype.lower()).document(muid).get().to_dict()
    if matchData == None:
        return "Failed: No such match exists"
    
    userData = db.collection(mtype.lower()).document(muid).collection("registeredUsers").where("hashedID", "==", uuid).get()
    if len(userData) != 1:
        return "Failed: You have not registered for this match"

    try:
        reportedUsers = matchData["reportedUsers"]
        for reportDict in reportedUsers:
            if uuid in reportDict["uuid"]:
                return "Failed: Cannot report more than once"

    except:
        reportedUsers = []
    
    reports = len(reportedUsers) + 1
    
    db.collection(mtype.lower()).document(muid).update({"reportedUsers": firestore.ArrayUnion([{"uuid": uuid, "report": reportData}])})
    
    try:
        hasSubmittedForReview = matchData["hasSubmittedForReview"]
    except:
        hasSubmittedForReview = False

    if reports > 20 and hasSubmittedForReview == False:
        db.collection(mtype.lower()).document(muid).update({"hasSubmittedForReview": True})
        db.collection("reports").document().set({"matchType": mtype.lower(), "muid": muid})
        
    return "Success"
    


@app.get("/api/rate")
def rate():
    ouid = request.args.get("ouid")
    rating = request.args.get("rating")

    if ouid == None or rating == None:
        return "Failed"
    
    if ouid == "" or rating == "":
        return "Failed"
    
    # checking valid ouid
    data = db.collection("organizer").document(ouid).get().to_dict()
    if data == None:
        return "Failed"

    # rating logic
    try:
        rating = int(rating)
        if rating <= 0  or rating > 5:
            return "Failed"
        try:
            total_rating = data["total_rating"]
        except KeyError:
            total_rating = 0
        try:
            total_reviews = data["total_reviews"]
        except KeyError:
            total_reviews = 0
        db.collection("organizer").document(ouid).update({"total_rating": total_rating + rating})
        db.collection("organizer").document(ouid).update({"total_reviews": total_reviews + 1})
    except:
        return "Failed"
    
    return "Success"


@app.route("/api/cancelTheMatch")
def cancelMatch():
    matchType = request.args.get("matchType")
    matchUid = request.args.get("muid")

    if matchUid == None or matchType == None:
        return "Failed"
    
    if matchUid == "" or matchType == "":
        return 'Failed'
    
    if matchType.lower() not in games:
        return "Failed"

    try:
        ref = db.collection(matchType).document(matchUid).get().to_dict()
        notifID = ref["notificationId"]
        started = ref["started"]
        if started == 2 or started == 1:
            return "Failed"
        refund()
        deleteChat(chatID=notifID)
        deleteGame(game=matchType.lower(), gameID=matchUid)
    except:
        return "Failed"

    return "Success"

app.run(debug=False)