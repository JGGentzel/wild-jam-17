extends "res://Ghost/Ghost.gd"

onready var healthbar = $HealthBar
onready var coin = preload("res://Pickups/Coin/Coin.tscn")
export var attack_cooldown = 1

enum states { idle, chase, attack, pickup, stun }
var target : Spatial
var target_displacement : Vector3

func _ready():
	#we can get rid of these signals
	connect("signal_damage", self, "display_damage")
	connect("signal_death", self, "die")
	speed = 2
	display_damage()
	target = globals.player_instance
	
func display_damage():
	healthbar.update_bar(float(health)/float(max_health) * 100)
	
func die():
	drop_coin()
	Events.emit_signal("enemy_die")
	globals.player_instance.set_mora(globals.player_instance.morality - 1)
	globals.player_instance.morality -= 1
	queue_free()

func drop_coin():
	var c = coin.instance()
	globals.coin_container.add_child(c)
	c.transform.origin = transform.origin

func _physics_process(delta):
	
	match its_sin:
		globals.SINS.wrath:
			act_aggressive()
		globals.SINS.gluttony:
			look_for_coins()
		globals.SINS.greed:
			if not look_for_coins():
				look_for_enemies()
		globals.SINS.envy:
			chase_target()
			if not is_player_looking_at_me() and is_in_attack_range():
				show_aggression()
		globals.SINS.lust:
			chase_target()
		globals.SINS.sloth:
			if is_in_attack_range():
				show_aggression()
		globals.SINS.pride:
			if not is_player_looking_at_me():
				act_aggressive()
	._physics_process(delta)
	
func act_aggressive():
	if is_in_attack_range():
		show_aggression()
	else:
		chase_target()
		
func look_for_coins():
	var coins = globals.coin_container.get_children()
	if coins.size() > 0:
		target = coins[0]
		calculate_displacement()
		chase_target()
		return true
	return false

func look_for_enemies():
	var enemies = globals.enemy_container.get_children()
	if enemies.size() > 0:
		target = enemies[0]
		calculate_displacement()
		chase_target()
		show_aggression()
		return true
	return false

func is_player_looking_at_me():
	var v1 = transform.origin - globals.player_instance.transform.origin
	return v1.dot(globals.player_instance.transform.basis.z ) > 0

func set_target(tar):
	target = tar

func calculate_displacement():
	if not target == null:
		target_displacement = transform.origin - target.transform.origin

func is_in_attack_range():
	return target_displacement.length() < 2

func show_aggression():
	calculate_displacement()	
	if is_in_attack_range() and can_attack:
		_attack()

func _attack():
	state_machine.travel("Anticipation")
	yield(get_tree().create_timer(.2), "timeout")
	._attack()
	can_attack = false
	yield(get_tree().create_timer(attack_cooldown), "timeout")
	can_attack = true

func chase_target():
	calculate_displacement()
	set_ghost_rotation(target_displacement.normalized())
	move_direction = target_displacement.normalized()
