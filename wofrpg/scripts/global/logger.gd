# ProgramWings LogCat V1.7.8
extends Node

const DEBUG = 0
const INFO = 1
const WARNING = 2
const ERROR = 3
const FATAL = 4

func stdout(msg: String, level: int):
	var time = OS.get_datetime()
	if level == DEBUG:
		print("[" + String(time.hour) + ":" + String(time.minute) + ":" + String(time.second) + " -   DEBUG]: " + msg)
	elif level == INFO:
		print("[" + String(time.hour) + ":" + String(time.minute) + ":" + String(time.second) + " -    INFO]: " + msg)
	elif level == WARNING:
		print("[" + String(time.hour) + ":" + String(time.minute) + ":" + String(time.second) + " - WARNING]: " + msg)
	elif level == ERROR:
		printerr("[" + String(time.hour) + ":" + String(time.minute) + ":" + String(time.second) + " -   ERROR]: " + msg)
	elif level == FATAL:
		printerr("[" + String(time.hour) + ":" + String(time.minute) + ":" + String(time.second) + " -   FATAL]: " + msg)
