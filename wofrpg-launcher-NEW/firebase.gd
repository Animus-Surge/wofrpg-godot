extends Node

signal errored(type, id)
signal success(type, data)

var idToken
var username
var remember

const WEBAPIKEY = "AIzaSyDrkZuYjzbynZNE5KfL5H0_TLUSAen0mQs"

const URL_SIGNUP = "https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=" + WEBAPIKEY
const URL_SIGNIN = "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=" + WEBAPIKEY
const URL_AUTDEL = "https://identitytoolkit.googleapis.com/v1/accounts:delete?key=" + WEBAPIKEY

const URL_DBFORE = "https://wofrpg-main.firebaseio.com/"

onready var http = get_parent().get_node("HTTPRequest")

func signUp(uname:String, email:String, password:String): #Password checking will happen in signup script
	http.request(URL_DBFORE + "users/" + uname + ".json")
	var result = yield(http, "request_completed") as Array
	if result[1] == 200:
		if result[3].get_string_from_ascii() != "null":
			emit_signal("errored", "Username already exists", "ERR_UNAME_EXISTS")
			return
		var reqbody = {
			"email":email.strip_edges(),
			"password":password.strip_edges()
		}
		http.request(URL_SIGNUP, [], false, HTTPClient.METHOD_POST, to_json(reqbody))
		result = yield(http, "request_completed") as Array
		if result[1] != 200:
			var error = JSON.parse(result[3].get_string_from_ascii()).result
			print(error.error)
			match error.error.errors[0].message:
				"INVALID_EMAIL":
					emit_signal("errored", "Email was invalid", "ERR_EMAIL_INVALID")
				"EMAIL_EXISTS":
					emit_signal("errored", "Email already exists", "ERR_EMAIL_EXISTS")
			return
		idToken = JSON.parse(result[3].get_string_from_ascii()).result.idToken
		reqbody = {
			"displayname":uname,
			"email":email,
			"verified":false #Will be worked with in the future
		}
		http.request(URL_DBFORE + "users/" + uname + ".json?access_token=" + idToken, [], false, HTTPClient.METHOD_PUT, to_json(reqbody))
		result = yield(http, "request_completed") as Array
		
		if result[1] != 200:
			emit_signal("errored", "Database pushing failed.", "ERR_HTTP-PUT_FAILURE")
			reqbody = {
				"idToken":idToken
			}
			http.request(URL_AUTDEL, [], false, HTTPClient.METHOD_POST, to_json(reqbody))
			result = yield(http, "request_completed") as Array
			return
		username = uname
		emit_signal("success", "TYPE_SIGNUP", JSON.parse(result[3].get_string_from_ascii()))
	else:
		emit_signal("errored", "Error reading from database", "ERR_HTTP-GET_FAILURE")

func signIn(uname, password):
	http.request(URL_DBFORE + "users/" + uname + ".json")
	var result = yield(http, "request_completed") as Array
	if result[1] == 200:
		var out = result[3].get_string_from_ascii()
		if out == "null":
			emit_signal("errored", "Username not found", "ERR_UNKNOWN_USERNAME")
			return
		var reqbody = {
			"email":JSON.parse(out).result.email,
			"password":password
		}
		http.request(URL_SIGNIN, [], false, HTTPClient.METHOD_POST, to_json(reqbody))
		result = yield(http, "request_completed") as Array
		if result[1] == 200:
			out = JSON.parse(result[3].get_string_from_ascii()).result
			idToken = out.idToken
			username = uname
			emit_signal("success", "TYPE_LOGIN", JSON.parse(result[3].get_string_from_ascii()).result)
		else:
			var data = JSON.parse(result[3].get_string_from_ascii()).result
			match data.error.message:
				"INVALID_PASSWORD":
					emit_signal("errored", "Incorrect Password", "ERR_INVALID_PASSWORD")
	else:
		emit_signal("errored", "Error reading from database", "ERR_HTTP-GET_FAILURE")

func readDatabase(path):
	http.request(URL_DBFORE + path)
	var result = yield(http, "request_completed") as Array
	if result[1] == 200:
		emit_signal("success", "TYPE_DBFETCH", JSON.parse(result[3].get_string_from_ascii()).result)
	else:
		emit_signal("errored", "Failed to read from database", "-")
