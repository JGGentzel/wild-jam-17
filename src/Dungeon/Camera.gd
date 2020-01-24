extends Camera

onready var anim : AnimationNodeStateMachine = $AnimationTree.get("parameters/playback")

func _ready():
	Events.connect("travel", self, "travel")

func travel(dir):
	anim.travel("Move" + globals.DIRECTIONS.keys()[dir])
