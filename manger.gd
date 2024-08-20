extends Node2D

signal move


@export var timer : Timer

func _ready() -> void:
	move.connect(_move)
	

func _move():
	$move.start()
