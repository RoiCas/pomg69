class_name StartScreen
extends Control

signal start_game_request()

const START_SCREEN_SCN : PackedScene = preload("res://interface/start_screen/start_screen.tscn")

static func new_start_screen() -> StartScreen:
  var new_start_screen : StartScreen = START_SCREEN_SCN.instantiate() as StartScreen
  return new_start_screen

@export var _play_button : Button


func _ready() -> void:
  _play_button.pressed.connect(on_play_button_pressed)


func on_play_button_pressed() -> void:
  start_game_request.emit()
