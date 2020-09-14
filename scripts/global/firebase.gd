extends Node

const APIKEY = "AIzaSyDrkZuYjzbynZNE5KfL5H0_TLUSAen0mQs"
const APIID = "wofrpg-main"

#authentication URLS
const authSI = "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=" + APIKEY
const authSU = "https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=" + APIKEY

#database URL
const dburl = "https://" + APIID + ".firebase.io/"

var uid
var username

signal failed(reason, action)
signal completed(action)
signal dbComplete(result)

var tuname
var tpass

var dbNeeded

var loggingIn = false

func userLogin(uname, password):
	tuname = uname
	tpass = password
	loggingIn = true
	getFromDB("users/" + tuname + ".json")

func userSignup(email, uname, password):
	var body = {
		"email":email,
		"password":password
	}
	http.request(authSU, [], false, HTTPClient.METHOD_POST, to_json(body))
	var result = yield(http, "request_completed") as Array
	if result[1] == 200:
		print("SIGNUP: OK")
		username = uname
		uid = JSON.parse(result[3].get_string_from_ascii()).result.idToken
		storeToDB("users/" + uname + ".json", {"email":email,"verified":false})
	else:
		print("SIGNUP: FAILED")
		emit_signal("failed", result[3].get_string_from_ascii(), "signup")

func getFromDB(field):
	http.request("https://wofrpg-main.firebaseio.com/" + field, [], false, HTTPClient.METHOD_GET, "{}")
	var result = yield(http, "request_completed") as Array
	if result[1] != 200:
		print("DBGET: FAILED")
		emit_signal("failed", result[3].get_string_from_ascii(), "dbGet")
	else:
		var jsonresult = JSON.parse(result[3].get_string_from_ascii()).result
		if jsonresult == null:
			emit_signal("failed", "{\"error\":\"Invalid username (username not found)!\"}", "dbGet")
			return
		print("DBGET: OK")
		if loggingIn:
			loginWithEmail(JSON.parse(result[3].get_string_from_ascii()).result.email)
		else:
			emit_signal("dbComplete", jsonresult)

func storeToDB(field, data: Dictionary):
	http.request("https://wofrpg-main.firebaseio.com/" + field + "?auth=" + uid, [], false, HTTPClient.METHOD_PUT, to_json(data))
	var result = yield(http, "request_completed") as Array
	if result[1] == 200:
		print("DBSTORE: OK")
		emit_signal("completed", "dbStore")
	else:
		print(result[3].get_string_from_ascii())
		emit_signal("failed", result[3].get_string_from_ascii(), "dbStore")
	

func loginWithEmail(email):
	var body = {"email":email, "password":tpass}
	http.request(authSI, [], false, HTTPClient.METHOD_POST, to_json(body))
	var result = yield(http, "request_completed") as Array
	if result[1] != 200:
		print(result[3].get_string_from_ascii())
		emit_signal("failed", result[3].get_string_from_ascii(), "login")
	else:
		print("LOGIN: OK")
		username = tuname
		uid = JSON.parse(result[3].get_string_from_ascii()).result.localId
		tuname = ""
		tpass = ""
		emit_signal("completed", "login")
