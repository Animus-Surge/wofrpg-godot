extends Node

const PORT = 48823
const MAXPLAYERS = 10

var players = {}

#player data: [enet_id, player_details, palette, username]

func _ready():
# warning-ignore:return_value_discarded
	get_tree().connect("network_peer_connected", self, "_peer_connect")
# warning-ignore:return_value_discarded
	get_tree().connect("network_peer_disconnected", self, "_peer_disconnect")
	
	start()

func start():
	var host = NetworkedMultiplayerENet.new()
	host.create_server(PORT, MAXPLAYERS)
	get_tree().network_peer = host
	lc.logmsg("Server ready", 1)

func _peer_connect(id):
	lc.logmsg("Player connected with id: " + String(id), 1)

func _peer_disconnect(id):
	if players.has(id):
		rpc("unregister", id)
		$"/root/testworld".rpc("erasePlayer", id)
	
	lc.logmsg("Player " + String(id) + " disconnected", 1)

remote func register(playerdata, palette):
	lc.logmsg("Registering player...", 0)
	var cid = get_tree().get_rpc_sender_id()
	playerdata[0] = cid
	players[cid] = {"data":playerdata,"palette":palette}
	for id in players:
		rpc_id(cid, "register", id, players[id])
	
	rpc("register", cid, players[cid])
	lc.logmsg("Registered player " + String(cid), lc.INFO)

puppetsync func unregister(id):
	lc.logmsg("Unregistering player...", 0)
	var wld = get_node("/root/testworld")
	wld.rpc("erasePlayer", id)
	players.erase(id)
	lc.logmsg("Player disconnected - " + String(id), lc.INFO)

remote func populate():
	var cid = get_tree().get_rpc_sender_id()
	var wld = get_node("/root/testworld")
	
	for player in wld.get_node("players").get_children():
		wld.rpc_id(cid, "spawn", player.position, player.get_network_master(), players[String(player.name)].data, players[String(player.name)].palette)
	
	wld.rpc("spawn", rvec(250, 250), cid, players[cid].data, players[cid].palette)

func rvec(x, y) -> Vector2:
	return Vector2(randf() * x, randf() * y)
