extends CenterContainer

onready var Heroes = $Heroes
onready var Hero = preload("res://States/Tavern/Hero.tscn")


var nb_heroes = 2

func _ready():
	var heroes = pick_random_heroes(nb_heroes)
	for hero in heroes:
		var hero_instance = Hero.instance()
		Heroes.add_child(hero_instance)
		hero_instance.init(hero)
		var _signal = hero_instance.connect("select_hero", self, "_on_select_hero")

func init(_params):
	pass


func pick_random_hero():
	if len(gm.heroes) < 1:
		return
	var hero = gm.heroes[randi() % gm.heroes.size()]
	var copyHero = hero.duplicate()
	return copyHero


func pick_random_heroes(nb):
	var heroes = []
	for _i in range(nb):
		heroes.append(pick_random_hero())
	return heroes


func _on_select_hero(hero):
	gm.select_hero(hero)
	gm._on_hero_selected()

