extends Node

const apikey = 'AIzaSyDrkZuYjzbynZNE5KfL5H0_TLUSAen0mQs'

const rgstr = 'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=' + apikey
const login = 'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=' + apikey
const profileUpdate = 'https://identitytoolkit.googleapis.com/v1/accounts:update?key=' + apikey
const lookup = 'https://identitytoolkit.googleapis.com/v1/accounts:lookup?key=' + apikey

onready var http = get_tree().get_root().get_node("http")

var uauthtoken: String
var username: String

signal doneLoggingIn(error)
signal doneRegistering(error)

func login(email, password):
	var body = {
		"email": email,
		"password": password
	}
	http.request(login,[],false,HTTPClient.METHOD_POST,to_json(body))
	var result = yield(http, "request_completed") as Array
	if result[1] == 200:
		uauthtoken = JSON.parse(result[3].get_string_from_ascii()).result.idToken
		#logcat.stdout("Successfully logged in user: " + uauthtoken, logcat.INFO)
		getUname()
	else:
		emit_signal("doneLoggingIn", "An error has occoured: " + String(result[1]))
	#TODO: error handling

func register(email, password, uname):
	var body = {
		"email": email,
		"password": password
	}
	http.request(rgstr,[],false,HTTPClient.METHOD_POST,to_json(body))
	var result = yield(http, "request_completed") as Array
	if result[1] == 200:
		uauthtoken = JSON.parse(result[3].get_string_from_ascii()).result.idToken
		#logcat.stdout("Successfully registered user: " + uauthtoken, logcat.INFO)
		updateProfile(uname)
	else:
		emit_signal("doneRegistering", "An error has occoured: " + String(result[1]))

func updateProfile(dname):
	var body = {
		"idToken":uauthtoken,
		"displayName":dname
	}
	http.request(profileUpdate,[],false,HTTPClient.METHOD_POST,to_json(body))
	var result = yield(http, "request_completed") as Array
	if !result[1] == 200:
		emit_signal("doneRegistering", "An error has occoured while setting username. " + String(result[1]))
		return
	username = JSON.parse(result[3].get_string_from_ascii()).result.displayName
	emit_signal("doneRegistering", null)

func getUname():
	var body = {
		"idToken": uauthtoken
	}
	http.request(lookup,[],false,HTTPClient.METHOD_POST,to_json(body))
	var result = yield(http, "request_completed") as Array
	#print(JSON.parse(result[3].get_string_from_ascii()).result)
	if !result[1] == 200:
		emit_signal("doneLoggingIn", "An error has occoured while getting your username. " + String(result[1]))
		return
	username = JSON.parse(result[3].get_string_from_ascii()).result.users[0].displayName
	emit_signal("doneLoggingIn", null)
