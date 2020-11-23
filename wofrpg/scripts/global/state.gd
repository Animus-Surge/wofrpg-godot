extends Node

var ipaddr
var ipport

signal success()
signal failed()
signal disconnected()

signal chatMessage(sender, message)

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
# warning-ignore:return_value_discarded
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

puppet func register(id, data, palette, frames = null):
	players[id] = {"data":data, "palette":palette, "frames":frames}

puppet func unregister(id):
	players.erase(id)

func getPlayers() -> Dictionary:
	return players

func prestart():
	var palette = null
	var frames = null
	if not gvars.useCustom:
		palette = Marshalls.raw_to_base64(gvars.plrpalette.get_data().get_data())
	else:
		frames = Marshalls.variant_to_base64(gvars.plrframes, true)
	rpc_id(1, "register", [0, gvars.plrdata, gvars.username], palette, frames)
	rpc_id(1, "populate")

func loaded():
	gvars.disconnect("doneLoading", self, "loaded")
	var peer = NetworkedMultiplayerENet.new()
	peer.create_client(ipaddr, ipport)
	get_tree().network_peer = peer

#chat

func sendChatMessage(message):
	rpc_id(1, "chatmessage", gvars.username, message)

puppet func chatmessage(sender, message):
	emit_signal("chatMessage", sender, message)
