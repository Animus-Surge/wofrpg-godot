extends Node

const PORT = 48823
const MAXPLAYERS = 10

var players = {}

func _ready():
	get_tree().connect("network_peer_connected", self, "_peer_connect")
	get_tree().connect("network_peer_disconnected", self, "_peer_disconnect")
	
	start()

func start():
	var host = NetworkedMultiplayerENet.new()
	host.create_server(PORT, MAXPLAYERS)
	get_tree().set_network_peer(host)

func _peer_connect(id):
	lc.logmsg("Player connected with id: " + String(id), 1)

func _peer_disconnect(id):
	if players.has(id):
		rpc("unregister")
		$"/root/Node2D".rpc("playerRemove", id)
	
	lc.logmsg("Player " + String(id) + " disconnected", 1)

remote func register(playerdata):
	var cid = get_tree().get_rpc_sender_id()
	
	players[cid] = playerdata
	for id in players:
		rpc_id(cid, "playerRegister", id, players[id])
	
	rpc("playerRegister", cid, players[cid])
	lc.logmsg("Registered player " + String(cid), lc.INFO)

puppetsync func unregister(id):
	players.erase(id)
	lc.logmsg("Player disconnected - " + String(id), lc.INFO)

remote func populate():
	var cid = get_tree().get_rpc_sender_id()
	var wld = get_node("/root/Node2D")
	
	for player in wld.get_node("players").get_children():
		wld.rpc_id(cid, "spawn", player.position, player.get_network_master())
	
	wld.rpc("spawn", rvec(250, 250), cid)

func rvec(x, y) -> Vector2:
	return Vector2(randf() * x, randf() * y)
