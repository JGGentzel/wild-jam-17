extends Sprite3D

onready var bar = $Viewport/HealthBar2D

func _ready():
	texture = $Viewport.get_texture()

func update_bar(value):
	bar.update_bar(value)
