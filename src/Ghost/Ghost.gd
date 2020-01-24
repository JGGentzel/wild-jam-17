extends KinematicBody
class_name Ghost

signal signal_damage
signal signal_death

export (globals.SINS) var its_sin

onready var slash : MeshInstance = $Slash
onready var attack_area : Area = $SlashArea
onready var sheet : MeshInstance = $Ghost/Skeleton/b_Sheet
var state_machine: AnimationNodeStateMachine
var speed : int = 8
var velocity : Vector3 = Vector3()
var can_move : bool = true
var can_take_damage : bool = true
var can_attack : bool = true
var move_direction: Vector3

var health : int = 10
var max_health: int = 10
var global_max_health: int = 20
var kb_time = .2
var damage_cooldown = .8
var has_advanced_control = false

func _ready():
	state_machine = $AnimationTree.get("parameters/playback")
	set_feature()
	set_color(globals.col_lookup[globals.SINS.keys()[its_sin]])

#movement loop
func _physics_process(delta):
	if can_move:
		velocity = Vector3()
		if move_direction.length() > 0:
			if has_advanced_control:
				velocity = Vector3(move_direction.x * -1, 0, move_direction.z * -1) * speed
			else:
				set_ghost_rotation(move_direction)
				velocity = get_global_transform().basis.z * speed
	move_and_slide(velocity, Vector3.UP)
	
func set_ghost_rotation(direction):
	var look_dir : Vector3 = translation + direction
	var rotTransform : Transform = transform.looking_at(look_dir,Vector3.UP)
	var thisRotation : Quat = Quat(transform.basis).slerp(rotTransform.basis, .1)
	set_transform(Transform(thisRotation, transform.origin))

#attack loop
func _attack():
	if can_attack:
		state_machine.travel("Slash")
		for col in attack_area.get_overlapping_bodies():
			if col.has_method("_take_damage"):
				#TODO: damge can be variable
				col._take_damage(1, translation)
			if col.has_method("open_shrine"):
				col.open_shrine()

func _take_damage(damage: int, position: Vector3):
	if can_take_damage:
		health -= damage
		if health <= 0:
			emit_signal("signal_death")
			return
		can_move = false
		can_take_damage = false
		velocity = (translation - position).normalized() * calculate_knockback(damage)
		velocity.y = 0
		emit_signal("signal_damage")
		yield(get_tree().create_timer(kb_time), "timeout")
		can_move = true
		yield(get_tree().create_timer(damage_cooldown), "timeout")
		can_take_damage = true

func calculate_knockback(damage) -> float:
	#2 is min 10 is max
	return (damage / global_max_health * 8 + 2) / kb_time
	
#customization
func set_color(color: Color):
	var mat = sheet.get_surface_material(0).duplicate()
	mat.albedo_color = color
	sheet.set_material_override(mat)

func set_feature():
	hide_all()
	match its_sin:
		globals.SINS.wrath:
			$Ghost/Skeleton/s_Wrath.visible = true
		globals.SINS.gluttony:
			$Ghost/Skeleton/s_Gluttony.visible = true
		globals.SINS.greed:
			$Ghost/Skeleton/s_Greed.visible = true
		globals.SINS.envy:
			$Ghost/Skeleton/s_Envy.visible = true
		globals.SINS.lust:
			$Ghost/Skeleton/s_Lust.visible = true
		globals.SINS.sloth:
			$Ghost/Skeleton/s_Sloth.visible = true
		globals.SINS.pride:
			$Ghost/Skeleton/s_Pride.visible = true
func hide_all():
	$Ghost/Skeleton/s_Wrath.visible = false
	$Ghost/Skeleton/s_Gluttony.visible = false
	$Ghost/Skeleton/s_Greed.visible = false
	$Ghost/Skeleton/s_Envy.visible = false
	$Ghost/Skeleton/s_Lust.visible = false
	$Ghost/Skeleton/s_Sloth.visible = false
	$Ghost/Skeleton/s_Pride.visible = false
