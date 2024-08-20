extends Node2D


var win = false
var curlvl := -1
var levels = [
	"res://levels/test.tscn",
	"res://levels/mindfield.tscn",
	"res://levels/finale.tscn"
]

var story = false

@onready var music := $music

func _ready() -> void:
	#_next()
	pass

func _win():
	win = true
	anim()
func _input(event: InputEvent) -> void:
	if(event.is_action_pressed("restart")):
		$AnimationPlayer.play("restart")

func switch_to(level):
	get_tree().call_deferred("change_scene_to_file",levels[level])

func _physics_process(delta: float) -> void:
	$CanvasLayer/Label.text = str(curlvl + 1) + "/" + str(levels.size())
	if(story):
		$ambient.volume_db -= 0.1
	else:
		$ambient.volume_db += 0.1
	$ambient.volume_db = max(min(-20.88,$ambient.volume_db),-200)

func _next():
	if(not $music.playing):
		$music.play()
	curlvl += 1
	switch_to(curlvl)

func anim():
	$switch.start()

func _restart():
	get_tree().reload_current_scene()


func _on_switch_timeout() -> void:
	$AnimationPlayer.play("next")
