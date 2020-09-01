extends Node

const apikey = 'AIzaSyDrkZuYjzbynZNE5KfL5H0_TLUSAen0mQs'

const rgstr = 'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=' + apikey
const login = 'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=' + apikey

var uauthtoken: String

signal doneLoggingIn(error)
signal doneRegistering(error)

func login(email, password, http: HTTPRequest):
	var body = {
		email: email,
		password: password
	}
	http.request(rgstr,[],false,HTTPClient.METHOD_POST,to_json(body))
	var result = yield(http, "request_completed") as Array
	print(result[1])
	if result[1] == 200:
		uauthtoken = JSON.parse(result[3].get_string_from_ascii()).result.idtoken
		logcat.stdout("Successfully registered user: " + uauthtoken, logcat.INFO)
		emit_signal("doneLoggingIn", null)
	else:
		emit_signal("doneLoggingIn", "An error has occoured.")
	#TODO: error handling

func register(email, password, http: HTTPRequest):
	var body = {
		email: email,
		password: password
	}
	http.request(login,[],false,HTTPClient.METHOD_POST,to_json(body))
	var result = yield(http, "request_completed") as Array
	print(result[1])
	if result[1] == 200:
		uauthtoken = JSON.parse(result[3].get_string_from_ascii()).result.idtoken
		logcat.stdout("Successfully logged in user: " + uauthtoken, logcat.INFO)
		emit_signal("doneRegistering", null)
	else:
		emit_signal("doneRegistering", "An error has occoured.")
