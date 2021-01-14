extends Spatial

###############################################################################################
# NOTE: ALL THINGS HERE ARE TEMPORARY. ALL ENTITY VARIABLES AND STUFF LIKE THAT WILL BE SAVED #
############# IN GLOBAL VARIABLES IN GVARS. THIS IS ALL HERE TO TEST THINGS. ##################
###############################################################################################

export(String) var sceneID = ""

func _ready():
	var sceneData
	var sceneFile = File.new()
	var err = sceneFile.open("res://data/" + sceneID + ".json", File.READ)
	if err == OK: #scene exists in scene databank
		sceneData = JSON.parse(sceneFile.get_as_text()).result
	
	if sceneData and sceneData.worldName == sceneID:
		#Load in the spawn point property and move the player object to the spawnpoint
		#Load in all objects
		#Load in the loot
		
		var playerSpawn = Vector3(sceneData.spawnpoint.x, sceneData.spawnpoint.y, sceneData.spawnpoint.z)
		$objects/player.translation = playerSpawn
		
		for entity in sceneData.objects:
			var e = load(entity.instance).instance()
			e.translation = Vector3(entity.position.x,entity.position.y,entity.position.z)
			if !entity.data.empty():
				pass #TODO
			$objects.add_child(e)
		for lootobject in sceneData.loot:
			match lootobject.type:
				"item":
					var item = load("res://entities/prefabs/item.tscn").instance()
					item.itemid = lootobject.stored_items[0]
					item._ready() #Ensure the models and materials are correct
					$loot.add_child(item)
				_:
					pass #TODO: invalid loot item format checking
		pass
