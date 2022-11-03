extends VBoxContainer

onready var CreatePopup = $CreatePopup
onready var Type = $CreatePopup/Fields/TypeField
onready var Name = $CreatePopup/Fields/NameField
onready var Cards = $CardsContainer/Cards

var Card = preload("res://CardManager/Card.tscn")

const uuid = preload("res://Utils/uuid.gd")
const json = preload("res://Utils/json.gd")

var cards = []

func _ready():
	var cards_json = json.load_json_file("res://cards.json")
	if cards_json:
		cards = cards_json
	save_cards()
	add_cards()

func _on_Back_pressed():
	var game_instance = load("res://Game/Main.tscn").instance()
	var root_node = get_tree().get_root()
	var manager_node = get_node("/root/Manager")
	root_node.remove_child(manager_node)
	manager_node.call_deferred("free")
	root_node.add_child(game_instance)

func save_cards():
	for card in cards:
		if not card.has('uuid'):
			card["uuid"] = uuid.v4()
	json.save_as_json("res://cards.json", cards)
	
func add_card(card):
	var card_instance = Card.instance()
	Cards.add_child(card_instance)
	var _signal = card_instance.connect("deleted", self, "card_deleted")	
	card_instance.init(card.duplicate())
	
func card_deleted(uuid):
	for index in len(cards):
		var card = cards[index]
		if card.uuid == uuid:
			cards.remove(index)
			break
	save_cards()
	
func add_cards():
	for card in cards:
		add_card(card)

func _on_CreatePopup_confirmed():
	var card = {}
	var type = Type.text.to_lower()
	card["type"] = type
	var name = Name.text.to_lower()
	card["name"] = name
	card["uuid"] = uuid.v4()
	cards.append(card)
	add_card(card)
	save_cards()


func _on_Create_pressed():
	CreatePopup.popup_centered()
