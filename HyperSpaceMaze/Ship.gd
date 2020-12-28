extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var loc = {'x':0, 'y':0}
var upTexture = load("res://HyperSpaceMaze/Ship_Rest_Up.png")
var rightTexture = load("res://HyperSpaceMaze/Ship_Rest_Right.png")
# Called when the node enters the scene tree for the first time.
func _ready():
	loc = {'x':0, 'y':0}


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
