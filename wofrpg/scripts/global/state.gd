extends Node

onready var logcat = get_node("/root/logcat")

var ipaddr
var ipport

signal success()
signal failed()
signal disconnected()

func _ready():
	# warning-ignore:return_value_discarded
	get_tree().connect("connected_to_server", self, "connected")
# warning-ignore:return_value_discarded
	get_tree().connect("connection_failed", self, "failed")
# warning-ignore:return_value_discarded
	get_tree().connect("server_disconnected", self, "disconnected")

const defaultPort = 48823

var players = {}

func join(ip, port = defaultPort):
	ipaddr = ip
	ipport = port
	var gvars = get_node("/root/globalvars")
	gvars.connect("doneLoading", self, "loaded")
	gvars.load_scene("res://scenes/testworld.tscn")

func connected():
	emit_signal("success")
	logcat.stdout("Connected to server", 1)
	prestart()

func failed():
	get_tree().set_network_peer(null)
	logcat.stdout("Failed to connect to server", 3)
	emit_signal("failed")

func disconnected():
	get_tree().set_network_peer(null)
	emit_signal("disconnected")

puppet func register(id, data):
	players[id] = data

puppet func unregister(id):
	players.erase(id)

func getPlayers() -> Dictionary:
	return players

func prestart():
	var gvars = get_node("/root/globalvars")
	rpc_id(1, "register", [0, gvars.plrdata, gvars.username])
	rpc_id(1, "populate")

func loaded():
	var gvars = get_node("/root/globalvars")
	gvars.disconnect("doneLoading", self, "loaded")
	var peer = NetworkedMultiplayerENet.new()
	peer.create_client(ipaddr, ipport)
	get_tree().network_peer = peer
