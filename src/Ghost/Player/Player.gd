extends "res://Ghost/Ghost.gd"
class_name Player
var can_cast : bool = true
var mana : int = 10
var morality: int = 50
var coins : int = 0

onready var fireball_origin : Position3D = $FireballOrigin
onready var fireball = preload("res://Effects/Fireball.tscn")
func _ready():
	globals.register_player(self)
	Events.connect("fireball_hit", self, "free_fireball")
	Events.connect("coin_picked_up", self, "pick_up_coin")
	call_deferred("emit_stats")
func emit_stats():
	Events.emit_signal("player_health_changed", health)
	Events.emit_signal("player_mana_changed", mana)
	Events.emit_signal("player_morality_changed", morality)
	
func _process(delta):
	get_input()

func get_input():
	if globals.is_playing:
		move_direction.x = int(Input.is_action_pressed("move_left")) - int(Input.is_action_pressed("move_right"))
		move_direction.z = int(Input.is_action_pressed("move_up")) - int(Input.is_action_pressed("move_down"))
		move_direction.normalized()
		if Input.is_action_just_pressed("Action") and globals.is_playing:
			_attack()
		if Input.is_action_just_pressed("Cast") and can_cast and can_attack and mana > 0 and globals.is_playing:
			cast_fireball()
		if Input.is_action_just_pressed("AdvancedControl"):
			has_advanced_control = true
		if Input.is_action_just_released("AdvancedControl"):
			has_advanced_control = false

func _attack():
	._attack()

func cast_fireball():
	can_cast = false
	use_mana(1)
	var fb_pos = fireball_origin.get_global_transform().origin
	var vec = (fb_pos - get_global_transform().origin).normalized()
	var fb = fireball.instance()
	
	fb.translation = fb_pos
	fb.translation.y = 1
	get_parent().add_child(fb)
	fb.launch_fireball(vec)

func free_fireball():
	can_cast = true

func pick_up_coin(other):
	if other.name == "Player":
		coins += 1
		Events.emit_signal("player_coins_changed", coins)

func use_coin():
	coins -= 1
	Events.emit_signal("player_coins_changed", coins)
	
func buy_morality():
	use_coin()
	morality += 2
	Events.emit_signal("player_morality_changed", morality)
	
func _take_damage(damage: int, position: Vector3):
	._take_damage(damage, position)
	Events.emit_signal("player_health_changed", health)
	if health <= 0:
		Events.emit_signal("game_over")
		
func set_health(h):
	health = h
	Events.emit_signal("player_health_changed", health)
	
	
func set_mana(m):
	mana = m
	Events.emit_signal("player_mana_changed", mana)
	
func set_mora(m):
	morality = m
	Events.emit_signal("player_morality_changed", morality)
	if morality >= 100 or morality <= 0:
		Events.emit_signal("game_over")
		
func use_mana(amount: int):
	mana -= amount
	Events.emit_signal("player_mana_changed", mana)
	
func change_morality(amount: int):
	morality += amount
	Events.emit_signal("player_morality_changed", morality)
	if morality <= 0:
		#game over - you lose
		pass
	elif morality >= 100:
		#game over - you win
		pass
