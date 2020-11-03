extends Node

const DEBUG = 0
const INFO = 1
const WARNING = 2
const ERROR = 3
const FATAL = 4

func logmsg(message, level: int):
	var time = OS.get_time()
	match level:
		DEBUG:
			print("[" + String(time.hour) + ":" + String(time.minute) + ":" + String(time.second) + "|  DEBUG]: " + message)
		INFO:
			print("[" + String(time.hour) + ":" + String(time.minute) + ":" + String(time.second) + "|   INFO]: " + message)
		WARNING:
			print("[" + String(time.hour) + ":" + String(time.minute) + ":" + String(time.second) + "|WARNING]: " + message)
		ERROR:
			printerr("[" + String(time.hour) + ":" + String(time.minute) + ":" + String(time.second) + "|  ERROR]: " + message)
		FATAL:
			printerr("[" + String(time.hour) + ":" + String(time.minute) + ":" + String(time.second) + "|  FATAL]: " + message)
		_:
			print("[" + String(time.hour) + ":" + String(time.minute) + ":" + String(time.second) + "|???????]: " + message)
