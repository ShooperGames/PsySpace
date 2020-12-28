extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$CenterContainer/GridContainer/MomLab.text = "HyperSpaceMomentum: " + Global.hsm as String
	$CenterContainer/GridContainer/MomEdit.connect("text_entered", self, "_on_MomEdit_text_entered")
	$CenterContainer/GridContainer/DiffLab.text = "HyperSpaceDifficulty: " + Global.hsd as String
	$CenterContainer/GridContainer/SightLab.text = "Character Sight: " + Global.player.skills['Sight'] as String
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_MomEdit_text_entered(new_text):
	Global.hsm = new_text as int
	$CenterContainer/GridContainer/MomLab.text = "HyperSpaceMomentum: " + Global.hsm as String


func _on_DiffEdit_text_entered(new_text):
	Global.hsd = new_text as int
	$CenterContainer/GridContainer/DiffLab.text = "HyperSpaceDifficulty: " + Global.hsd as String


func _on_SightEdit_text_entered(new_text):
	Global.player.skills['Sight'] = new_text as int
	$CenterContainer/GridContainer/SightLab.text = "Character Sight: " + Global.player.skills['Sight'] as String
