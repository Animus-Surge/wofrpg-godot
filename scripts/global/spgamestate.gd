extends Node

var charname

var body
var wings
var horns
var eyes

var atkdmg = 20

func init(characterData: Dictionary):
	charname = characterData.name
	body = Color(characterData.colors[0].r, characterData.colors[0].g, characterData.colors[0].b)
	wings = Color(characterData.colors[1].r, characterData.colors[1].g, characterData.colors[1].b)
	horns = Color(characterData.colors[2].r, characterData.colors[2].g, characterData.colors[2].b)
	eyes = Color(characterData.colors[3].r, characterData.colors[3].g, characterData.colors[3].b)
