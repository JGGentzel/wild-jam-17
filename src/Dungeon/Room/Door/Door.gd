extends Spatial

export (globals.DIRECTIONS) var direction
onready var door = $MeshInstance
onready var trigger = $Area
onready var trigger_shape = $Area/CollisionShape
onready var anim = $AnimationPlayer

func _ready():
	Events.connect("travel", self, "disable_door")

func close():
	anim.play("Close")
func open():
	trigger_shape.disabled = false
	anim.play("Open")
func _on_Area_body_entered(body):
	if not globals.in_room_transition:
		Events.emit_signal("travel", direction)
		globals.in_room_transition = true

func disable_door(dir):
		trigger_shape.disabled = true
