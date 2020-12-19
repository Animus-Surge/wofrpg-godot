extends Control

#callback signals to root of scene
signal itemDropped(item)

func _ready():
	$inventory.hide()

####################
# INVENTORY SYSTEM #
####################

var itemsInInventory = [] #Array of dictionaries

#Signal callback from root
func itemPickedUp(_item:Dictionary):
	pass # TODO

# TODO: inventory callbacks for trading and shopping
