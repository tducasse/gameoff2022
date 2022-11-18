extends Node2D

onready var Music: AudioStreamPlayer = $Music
onready var SFX: AudioStreamPlayer = $SFX
onready var tween_out = $TweenOut
onready var tween_in = $TweenIn

onready var tavern = preload("res://Assets/Music/tavern.ogg")
onready var menu = preload("res://Assets/Music/tavern.ogg")
onready var map = preload("res://Assets/Music/tavern.ogg")
onready var battle = preload("res://Assets/Music/battle.ogg")

var current_stream = null

func play_tavern():
	play(tavern)


func play_map():
	play(map)


func play_menu():
	play(menu)


func play_battle():
	play(battle)


func fade(stream):
	if Music.stream == stream:
		return
	current_stream = stream
	fade_out()


func play(stream):
	if Music.stream == stream:
		return
	Music.stream = stream
	Music.play()


func pause():
	Music.stop()


func fade_out():
	tween_out.interpolate_property(Music, "volume_db", 0, -80, 0.5, 1, Tween.EASE_IN, 0)
	tween_out.start()


func fade_in():
	tween_in.interpolate_property(Music, "volume_db", -80, 0, 0.2, 1, Tween.EASE_IN, 0)
	tween_in.start()

func _on_TweenOut_tween_step(_object, _key, elapsed, _value):
	if elapsed > 0.3:
		Music.stream = current_stream
		Music.volume_db = -80
		Music.play()
		fade_in()


func play_sfx(stream):
	SFX.stream = stream
	SFX.play()
