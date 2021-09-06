extends Node2D

onready var personagem = get_node("personagem")
onready var camera = get_node("dead_camera")

func _ready():
	pass 

func change_camera():
	camera.set_global_position(personagem.get_node("camera").get_camera_position())
	camera.make_current()


func _on_personagem_morreu():
	change_camera()
	
	
	get_node("spawn_timer").start()


func _on_spawn_timer_timeout():
	reviver()

func reviver():
	personagem.set_position(get_node("spawn_point").get_position())
	personagem.reviver()

func _on_personagem_fim():
	change_camera()
	get_node("spawn_timer").start()
	