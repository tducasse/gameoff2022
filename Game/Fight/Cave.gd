extends MarginContainer


onready var Card = preload("res://Common/Card/Card.tscn")
const json = preload("res://Utils/json.gd")
onready var Hand: Hand = $VBoxContainer/Bench/Hand


var cards = []

func _ready():
	var cards_json = json.load_json_file("res://Assets/Cards/cards.json")
	if cards_json:
		cards = cards_json


func _on_Draw_pressed():
	var card = pick_random_card()
	Hand.add_card(card)


func pick_random_card():
	if len(cards) < 1:
		return
	var card = cards[randi() % cards.size()]
	var copyCard = card.duplicate()
	return copyCard
