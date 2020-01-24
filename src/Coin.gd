extends Spatial

func _ready():
	$AnimationPlayer.play("spin")

func _on_Area_body_entered(body: Spatial):
	if body.name == "Player" or body.name == "greed" or body.name == "gluttony":
		Events.emit_signal("coin_picked_up", body)
		queue_free()
