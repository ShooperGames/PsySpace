extends Node

class Character:
	var skills = {}
	var name
	func _init(named):
		self.name = named

var player = Character.new("Player")
var hsm = 25
var hsd = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	player.skills['Sight'] = 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
