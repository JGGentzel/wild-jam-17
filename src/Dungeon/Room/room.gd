extends Spatial
onready var north_door = $Doors/NorthDoor
onready var south_door = $Doors/SouthDoor
onready var east_door = $Doors/EastDoor
onready var west_door = $Doors/WestDoor

onready var enemy = preload("res://Ghost/Enemy/Enemy.tscn")

func _ready():
	globals.coin_container = $Coins
	globals.enemy_container = $Enemies
	Events.connect("enemy_die", self, "check_for_open")
	Events.connect("game_over", self, "set_game_over")

func check_for_open():
	yield(get_tree().create_timer(.5), "timeout")
	if globals.enemy_container.get_children().size() <= 0:
		globals.set_room_status(globals.get_room_index(), true)
		open_all_doors()

func enter_room(dir):
	close_all_doors()
	set_player_position(dir)
	spawn_enemies()

func close_all_doors():
	north_door.close()
	south_door.close()
	east_door.close()
	west_door.close()

func open_all_doors():
	var doors = globals.get_bordering_rooms()
	if doors[0] != null:
		north_door.open()
	if doors[1] != null:
		south_door.open()
	if doors[2] != null:
		east_door.open()
	if doors[3] != null:
		west_door.open()

func set_player_position(dir):
	var play : Spatial = globals.player_instance
	yield(get_tree().create_timer(.5), "timeout")
	match dir:
		globals.DIRECTIONS.North:
			play.transform.origin = $Doors/EnterSouth.transform.origin
		globals.DIRECTIONS.South:
			play.transform.origin = $Doors/EnterNorth.transform.origin
		globals.DIRECTIONS.East:
			play.transform.origin = $Doors/EnterWest.transform.origin
		globals.DIRECTIONS.West:
			play.transform.origin = $Doors/EnterEast.transform.origin
		null:
			play.transform.origin = $Doors/EnterStart.transform.origin
	globals.in_room_transition = false

func spawn_enemies():
	var cr = globals.get_current_room()
	if cr[0] == "shrine" or cr[1]:
		yield(get_tree().create_timer(.5), "timeout")
		open_all_doors()
		return
	var i = 1
	for r in globals.get_bordering_rooms():
		var t = globals.get_room_type(r)
		if not t[0] == "empty" and not t[0] == "shrine":
			spawn_one_enemy(
				get_node("Spawners/Spawn"+str(i)).transform.origin, globals.SINS[t[0]], t[0]
				)
		i += 1
	var current_room = globals.get_current_room()
	if not current_room[0] == "empty":
		spawn_one_enemy($Spawners/Spawn5.transform.origin, globals.SINS[current_room[0]], current_room[0])
	#if bad time spawn one more

func spawn_one_enemy(pos, its_sin, name):
	var e = enemy.instance()
	e.its_sin = its_sin
	e.name = name
	globals.enemy_container.add_child(e)
	e.transform.origin = pos

func set_color(key: String):
	var c = globals.col_lookup[key]
	var mat = $Room.get_surface_material(0).duplicate()
	mat.albedo_color = c
	$Room.set_material_override(mat)
	if key == "shrine":
		$pedestal.transform.origin.y = 0
	else:
		$pedestal.transform.origin.y = -10
		
func set_game_over():
	set_player_position(null)
	globals.player_instance.set_ghost_rotation(Vector3(0, 0, -10))
	for e in globals.enemy_container.get_children():
		e.queue_free()
	set_color("shrine")
	open_all_doors()
