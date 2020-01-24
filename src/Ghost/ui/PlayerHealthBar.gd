extends TextureProgress

var num_skulls = 10
var num_mana = 10
func _ready():
	Events.connect("player_health_changed", self, "change_health_bar")
	Events.connect("player_mana_changed", self, "change_mana_bar")
	Events.connect("player_morality_changed", self, "change_morality_bar")
	Events.connect("player_coins_changed", self, "change_coins")


func change_health_bar(health: int):
	value = float(health) / float(num_skulls) * 100

func change_mana_bar(mana: int):
	$PlayerManaBar.value = float(mana) / float(num_mana) * 100
	
func change_morality_bar(morality: int):
	$PlayerMoralityBar.value = morality
	$PlayerMoralityBar/Morality.text = str(morality) + "/100"

func change_coins(coins: int):
	$PlayerCoins/Label.text = "Coins: " + str(coins)
