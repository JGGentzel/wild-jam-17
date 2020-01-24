extends TextureRect

func _ready():
	Events.connect("open_shrine", self, "open_shrine")

func open_shrine():
	get_node(".").show()

func _on_Okay_button_down():
	hide()
	yield(get_tree().create_timer(.5), "timeout")
	globals.is_playing = true

func _on_BuyMorality_button_down():
	var p = globals.player_instance
	if p.coins > 0:
		p.buy_morality()

func _on_BuyMana_button_down():
	var p = globals.player_instance
	if p.coins > 0 and p.mana < 10:
		p.use_coin()
		globals.player_instance.set_mana(globals.player_instance.mana + 1)

func _on_BuyHealth_button_down():
	var p = globals.player_instance
	if p.coins > 0 and p.health < 10:
		p.use_coin()
		p.set_health(p.health + 1)
