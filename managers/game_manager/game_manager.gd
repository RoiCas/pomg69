class_name GameManager
extends Node

signal round_start()
signal round_end()

static var game_manager : GameManager = null:
  set(val):
    assert(is_instance_valid(game_manager) == false, "Multiple GameManager!")
    game_manager = val

@export_category("REQUIRED")
@export var _game_area : Area2D = null
@export var _ball : Ball = null
@export var _enemy : Enemy = null


func _init() -> void:
  game_manager = self


func _ready() -> void:
  start_game()


func start_game() -> void:
  _game_area.body_exited.connect(on_ball_exited)

  _enemy.set_target_ball(_ball)


func on_ball_exited(exited_ball: Ball) -> void:
  if(is_instance_valid(exited_ball) == false):
    return

  round_end.emit()
