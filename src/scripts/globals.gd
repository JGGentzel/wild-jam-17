extends Node
#instances
var player_instance : Spatial
var coin_container : Spatial
var enemy_container : Spatial
#room information
var rooms := []
var room_x : int = 0
var room_y : int = 0
var total_rooms_x : int
var total_rooms_y : int
#states
var in_room_transition : bool = false
var is_playing = false
var title_heading = "You have died and you were a terrible person"
#lookup tables
var col_lookup := {
	"shrine": Color(0.1, 0.1, 0.1, 1),
	"wrath": Color(1,0.2,0.298,1),
	"gluttony": Color(0.909,0.686,1),
	"greed": Color(0.909,0.843,0.274,1),
	"envy": Color(0.674,1,.349,1),
	"lust": Color(0.250,.360,1,1),
	"sloth": Color(0.278,0.921,0.905,1),
	"pride": Color(0.392,0.149,0.1,1),
	"empty": Color(1,1,1,1)
}
enum DIRECTIONS {
	North, South, East, West
}
enum SINS {
	wrath, gluttony, greed, envy, lust, sloth, pride
}
#methods
func register_player(player):
	player_instance = player

#n, s, e, w
func get_bordering_rooms():
	var rooms = []
	#n
	rooms.append(get_room(room_x, room_y - 1, room_y > 0))
	#s
	rooms.append(get_room(room_x, room_y + 1, room_y < total_rooms_y - 1))
	#e
	rooms.append(get_room(room_x + 1, room_y, room_x < total_rooms_x - 1))
	#w
	rooms.append(get_room(room_x - 1, room_y, room_x > 0))
	return rooms
	
func get_current_room():
	return rooms[get_room(room_x, room_y, true)]

func get_room_type(index):
	if not index == null:
		return rooms[index]
	return ["empty", false]

func get_room(x, y, is_border):
	if is_border:
		return y * total_rooms_y + x
	else:
		return null

func get_room_index():
	return room_y * total_rooms_y + room_x

func set_room_status(index, status):
	rooms[index][1] = status
	
func game_over():
	room_x = 7
	room_y = 7
	is_playing = false
	player_instance.set_health(10)
	player_instance.set_mana(10)
	player_instance.set_mora(50)
