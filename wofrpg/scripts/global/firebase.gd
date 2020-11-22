extends Node

const APIKEY = "AIzaSyDrkZuYjzbynZNE5KfL5H0_TLUSAen0mQs"
const APIID = "wofrpg-main"

#authentication URLS
const authSI = "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=" + APIKEY
const authSU = "https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=" + APIKEY

#database URL
const dburl = "https://" + APIID + ".firebase.io/"

var uid

signal failed(reason, action)
signal completed(action)
signal dbComplete(result)

var tuname
var tpass

var dbNeeded

var loggingIn = false
var userdata:Dictionary

func userLogin(uname, password):
	tuname = uname
	tpass = password
	loggingIn = true
	getFromDB("users/" + tuname + ".json")

func getFromDB(field):
# warning-ignore:return_value_discarded
	http.request("https://wofrpg-main.firebaseio.com/" + field, [], false, HTTPClient.METHOD_GET, "{}")
	var result = yield(http, "request_completed") as Array
	if result[1] != 200:
		logcat.stdout("DBGET: FAIL", logcat.DEBUG)
		emit_signal("failed", result[3].get_string_from_ascii(), "dbGet")
	else:
		var jsonresult = JSON.parse(result[3].get_string_from_ascii()).result
		if jsonresult == null:
			logcat.stdout("DBGET: FAIL", logcat.DEBUG)
			emit_signal("failed", "{\"error\":\"Invalid username (username not found)!\"}", "dbGet")
			return
		logcat.stdout("DBGET: OK", logcat.DEBUG)
		userdata = jsonresult
		if loggingIn:
			loginWithEmail(userdata.email)
			loggingIn = false
		else:
			emit_signal("dbComplete", jsonresult)

func storeToDB(field, data: Dictionary):
# warning-ignore:return_value_discarded
	http.request("https://wofrpg-main.firebaseio.com/" + field + "?auth=" + uid, [], false, HTTPClient.METHOD_PUT, to_json(data))
	var result = yield(http, "request_completed") as Array
	if result[1] == 200:
		logcat.stdout("DBSTORE: OK", logcat.DEBUG)
		emit_signal("completed", "dbStore")
	else:
		logcat.stdout("DBSTORE: FAIL", logcat.DEBUG)
		emit_signal("failed", result[3].get_string_from_ascii(), "dbStore")
	

func loginWithEmail(email):
	var body = {"email":email, "password":tpass}
# warning-ignore:return_value_discarded
	http.request(authSI, [], false, HTTPClient.METHOD_POST, to_json(body))
	var result = yield(http, "request_completed") as Array
	if result[1] != 200:
		logcat.stdout("LOGIN: FAIL", logcat.DEBUG)
		emit_signal("failed", result[3].get_string_from_ascii(), "login")
	else:
		logcat.stdout("LOGIN: OK", logcat.DEBUG)
		gvars.username = tuname
		gvars.userattributes = userdata.get("attrs", "")
		uid = JSON.parse(result[3].get_string_from_ascii()).result.localId
		tuname = ""
		tpass = ""
		gvars.loggedIn = true
		emit_signal("completed", "login")
