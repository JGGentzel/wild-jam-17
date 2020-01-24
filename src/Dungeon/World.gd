extends Spatial

onready var room = $Room
var player_position = Vector2(7, 7)

func _ready():
	build_rooms_data(load_data())
	globals.room_x = 14
	globals.room_y = 14
	enter_room(null)
	Events.connect("travel", self, "move_in_direction")
	Events.connect("game_over", self, "set_game_over")

func load_data():
	var dungeon_data : Image = load("res://rooms.png").get_data()
	globals.total_rooms_x = dungeon_data.get_width()
	globals.total_rooms_y = dungeon_data.get_height()
	dungeon_data.lock()
	return dungeon_data

func build_rooms_data(dungeon_data):
	for y in globals.total_rooms_y:
		for x in globals.total_rooms_x:
			globals.rooms.append(
				[get_sin(dungeon_data.get_pixel(x, y)), false]
				)

func enter_room(dir):
	room.enter_room(dir)
	room.set_color(get_room_color())

func move_in_direction(dir):
	match dir:
		globals.DIRECTIONS.North:
			globals.room_y -= 1
		globals.DIRECTIONS.South:
			globals.room_y += 1
		globals.DIRECTIONS.East:
			globals.room_x += 1
		globals.DIRECTIONS.West:
			globals.room_x -= 1
	enter_room(dir)

func get_sin(color) -> String:
	match color:
		Color(0,0,0,1): return "shrine"
		Color(1,0,0,1): return "wrath"
		Color(1,0.501961,0,1): return "gluttony"
		Color(1,1,0,1): return "greed"
		Color(0,1,0,1): return "envy"
		Color(0,0,1,1): return "lust"
		Color(0,1,1,1): return "sloth"
		Color(1,0,1,1): return "pride"
		Color(1,1,1,1): return "empty"
	return "empty"

func get_room_color():
	return globals.rooms[globals.get_room_index()][0]
	
func get_room_cleared():
	return globals.rooms[globals.get_room_index()][1]
