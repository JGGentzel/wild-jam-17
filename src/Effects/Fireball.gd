extends Spatial
export var is_static : bool = false
onready var emitters : Array = [$Flames1, $Flames2, $Flames3, $Flames4, $Smoke]
var velocity : Vector3 = Vector3(0,0,0)
func _physics_process(delta):
	if !is_static:
		translation += velocity * delta

func launch_fireball(direction: Vector3):
	for emitter in emitters:
		emitter.set_amount(20)
	velocity = direction * 20


func _on_FireballCollision_body_entered(body):
	if body.has_method("_take_damage"):
		body._take_damage(1, translation)
	if !is_static:
		#explode animation
		queue_free()
	Events.emit_signal("fireball_hit")
