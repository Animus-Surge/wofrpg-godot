extends Node2D

var texture : Texture
var itemName : String

func _init(itemName, texture):
	self.texture = texture
	self.itemName = itemName
	
func getTexture():
	return texture

func use():
	var description = editor_description.split(" ")
	print(description[0])
