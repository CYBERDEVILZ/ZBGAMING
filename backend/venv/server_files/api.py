"""
OPTIMIZATIONS / IDEAS
---------------------

########################## LOGIC SECTION ###############################

IMPORTANT!!!
ADD SEARCH USER FEATURE TO LOOK FOR PLAYERS BY OTHER USERS

IMPORTANT!!!
UNIQUE ID FOR PLAYERS --  FIREBASE UID (SECRET) => SHA256 HASH => BLOB (BYTE STRING) [0XFD0XFA0XAE -- fdfaae]

IMPORTANT!!!
STOP MATCH LOGIC
ORGANIZER STOPS THE MATCH. HE IS FORCED TO SELECT A WINNER FROM THE REGISTERED USERS. AFTER SELECTING THE WINNER,
A PUSH NOTIFICATION IS SENT WHICH REDIRECTS THE USER TO THE CONTEST DETAILS PAGE WHERE HE HAS AN OPTION TO REPORT AND ALSO SEE THE WINNER OF THE MATCH.
VALIDATORS VALIDATE WHETHER THE WINNER IS LEGIT IFF REPORTS POUR IN.
THE USER GETS REMOVED FROM THE CHAT GROUP AS WELL AND 'LOST' STATUS IS UPDATED ON ALL THE WINNERS.

IMPORTANT!!!
IF MATCH IS NOT 'ONGOING' EVEN AFTER THE DATE HAS PASSED OR MATCH FOUND INVALID, AUTOMATICALLY THE MATCH STATUS WILL BE SET TO FINISHED, 
MONEY WILL BE REFUNDED TO ALL AND WON VARIABLE SET TO 2. IF ALL IS LEGIT THEN MONEY FUNDED TO THE WINNER THE NEXT DAY AND ORGANIZER AND
AMOUNTGIVEN VARIABLE OF ORGANIZER IS UPDATED

IMPORTANT!!!
POLICY NOT ADDED FOR ORGANIZER SIGNUP

IMPORTANT!!!
BACKEND TO CALCULATE ORGANIZER RATINGS: BASED ON RATINGS PURELY FROM PLAYERS.

IMPORTANT!!!
CREATE BACKEND TO CALCULATE ORGANIZER LEVEL BASED ON AMOUNTGIVEN PARAMETER.

IMPORTANT!!!
I HAVE USED TOKENS FOR PUSH NOTIFICATION. CONVERT THEM INTO TOPICS FOR FASTER SENDING. OR USE BACKGROUND WORKER (LEAST PREFERRED)

IMPORTANT!!!
VALIDATE ORGANIZER SIGNIN AS WELL. NORMAL PLAYERS CAN ALSO SIGN IN AS ORGANIZERS AND THERE IS A BUG!

IMPORTANT!!!
ORGANIZER VERIFICATION
IN ORDER TO CREATE MATCHES, THE ORGANIZER SHOULD BE VERIFIED (KYC).
AFTER THE MATCH ENDS, A 24 HOUR WINDOW IS GIVEN FOR ANY REPORTS. IF REPORTS ARE RECEIVED THEN THE STREAM IS WATCHED BY VERIFIERS.
IF SOMETHING IS OFF, LIKE WRONG LINK, CHEATING, MATCH STARTED EARLY, ETC, THE MATCH IS FORFEITED AND MONEY IS REFUNDED.

IMPORTANT!!!
CREATE LOGIC FOR PAYOUTS

IMPORTANT!!!
MAKE A CLOUD FUNCTION THAT CLEANS DATABASE.

Validator should be able to validate a match
Backend to calculate organizer levels based on prizes given
Organizer account delete
Customer Care chat feature, account related assistance, monetary related assistance


########################## DESIGN SECTION ###############################

IMPORTANT!!!
SHOW WHO WON AT CONTEST DETAILS PAGE

IMPORTANT!!!
DISABLE REGISTER BUTTON FOR INELIGIBLE USERS BASED ON SKILL

IMPORTANT!!!
DESIGN A GOOD UI TO ADD IGID. MAKE SURE THE PREVIOUS IGID IS VISIBLE TO THE USER

IMPORTANT!!!
I HAVE ADDED TWO NEW IMAGES: ZBUNKER BANNER SHORT AND ZBUNKER BANNER UPSIDE DOWN SHORT. MAKE SURE TO REPLACE THE ORIGINAL WITH SHORT AND 
CHECK THE RESULT. REALLY IMPORTANT TO REDUCE SIZE!

IMPORTANT!!!
FRONTEND FOR LINKED ACCOUNTS NOT COMPLETED.

IMPORTANT!!!
CREATE FRONTEND FOR ORGANIZER VERIFIED. JUST ADD VERIFY ME TAGS LIKE THAT OF USER VERIFICATION

IMPORTANT!!!
ORGANIZER CAN POST SCOREBOARD ON HIS PAGE

IMPORTANT!!!
ADD CIRCULAR PROGRESS INDICATOR WHEN ORGANIZER CONFIRMS THE USER WON


###################### FEATURES FOR FUTURE DEVS ##############################

TIME OF MATCH START SHOULD BE SHOWN TO THE USER WHILE REGISTERING FOR THE MATCH

ONE WAY TEMPORARY CHAT SECTION FOR USERS REGISTERED FOR A MATCH. ALL ONE WAY DISCUSSION WILL BE TAKEN PLACE THERE

OPTIMIZE USER LEVEL CALCULATION AS WELL AS ORGANIZER LEVEL CALCULATION (IF EXISTS)


"""


from datetime import datetime, timedelta
import json
from lib2to3.pytree import Base
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
    idToken = request.args.get("idToken")
    isVerified = False
    imageurl = None

    if username != None and email != None and docId != None:
        if username != "" and email != "" and docId != "":
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
                        print(r.text)
                        if r.status_code != 200:
                            return "Failed"

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
            

            # checking for already registered..
            registeredMatches = (
                db.collection("userinfo").document(useruid).collection("registered").get()
            )
            matchId = [match.id for match in registeredMatches]
            if matchuid in matchId:
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
                ).document(matchuid).set(
                    {"date": date, "matchType": matchType, "name": name, "uid": uid, "notificationId": notifId}
                )

                # add to history
                db.collection("userinfo").document(useruid).collection("history").document(
                    matchuid
                ).set({"date": date, "matchType": matchType, "name": name, "uid": uid, "paid": paid, "won": -1, "skill": skill})

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
                    ).document(matchuid).set(
                        {"date": date, "matchType": matchType, "name": name, "uid": uid, "notificationId": notifId}
                    )

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
                    ).set({"date": date, "matchType": matchType, "name": name, "uid": uid, "paid": paid, "won": -1, "skill": skill})


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

        # for notification room
        secret_key = "shinra_tensei"
        datething = str(datetime.now())
        toHash = uid+secret_key+datething
        hashedValue = hashlib.sha256(toHash.encode()).digest()

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
        if data["reg"] < 80:
            return "Failed: Not enough registrations"
            
        userMessageTokens = data["userMessageTokens"]
        name = data["name"]
        for token in userMessageTokens:
            print(token)
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
        




app.run(debug=True)