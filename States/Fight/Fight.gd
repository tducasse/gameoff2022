extends MarginContainer


onready var Enemy = $VBoxContainer/Field/Enemy
onready var Rewards = $Rewards

var enemy = null
var reward = null

func _ready():
	Sounds.play_battle()



func init(params):
	Rewards.hide()
	Rewards.dialog_text = ""
	Rewards.dialog_autowrap = true
	enemy = pick_random_monster(params.value)
	Rewards.get_close_button().visible = false
	Enemy.init(enemy)
	gm.start_fight()


func pick_random_monster(options):
	if len(options) < 1:
		return
	var monster = options[randi() % options.size()]
	return gm.monsters.get(monster).duplicate()


func _on_Enemy_monster_dead(last):
	Sounds.pause()
	if last:
		gm.emit_signal("monster_dead", last)
	else:
		reward = get_reward()
		if reward:
			Rewards.dialog_text = reward
			Rewards.popup_centered_clamped(Vector2(320, 200))
		else:
			gm.emit_signal("monster_dead", last)


func _on_Rewards_confirmed():
	gm.emit_signal("monster_dead", false)


func get_reward():
	var reward_text = []
	var rewards = gm.nodes[gm.current_level_key].get("rewards")
	if not rewards:
		return false
	var cards = rewards.get("cards")
	var hp = rewards.get("hp")
	if hp:
		gm.get_reward_hp(hp)
		reward_text.append("Heal: " + str(hp))
	if len(cards) > 0:
		var card = cards[randi() % cards.size()]
		gm.add_card_to_deck(card)
		reward_text.append("Card: " + card)
	return "\n".join(reward_text)
