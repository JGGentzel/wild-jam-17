extends MarginContainer
onready var Message = get_node(".")
onready var Heading = $TextureRect/MarginContainer/VBoxContainer/Heading
onready var SinLeft = $TextureRect/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/Sin/SinLeft
onready var Sin = $TextureRect/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/Sin/Sin
onready var SinRight = $TextureRect/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/Sin/SinRight
onready var OkayButton = $TextureRect/MarginContainer/VBoxContainer/OkayButton

func _ready():
	Events.connect("game_over", self, "show_title")

func _on_OkayButton_button_down():
	Message.hide()
	globals.is_playing = true


func _on_SinLeft_button_down():
	sin_move(-1)

func _on_SinRight_button_down():
	sin_move(-1)
	
func sin_move(i):
	var val = globals.player_instance.its_sin + i
	if val > 6:
		val = 0
	if val < 0:
		val = 6
	globals.player_instance.its_sin = val
	Sin.text = "Your sin in life was " + globals.SINS.keys()[val]
	globals.player_instance.set_feature()
	globals.player_instance.set_color(globals.col_lookup[globals.SINS.keys()[val]])

func show_title():
	Message.show()
