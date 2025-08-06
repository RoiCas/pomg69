class_name GameManager
extends Node

signal exit_game_request()
signal round_start()
signal round_end()
signal game_end()

const GAME_MANAGER_SCN : PackedScene = preload("res://managers/game_manager/game_manager.tscn")

static var game_manager : GameManager = null:
  set(val):
    assert(is_instance_valid(game_manager) == false, "Multiple GameManager!")
    game_manager = val

@export_category("REQUIRED")
@export var _game_area : Area2D
@export var _ball : Ball
@export var _enemy : Enemy
@export var _score_manager : ScoreManager
@export var _round_start_counter : RoundStartCounter
@export var _end_message : EndMessage
@export var _pause_menu : PauseMenu
@export var _pause_message : PauseMessage


static func new_game_manager() -> GameManager:
  var new_instance : GameManager = GAME_MANAGER_SCN.instantiate() as GameManager
  return new_instance


func _init() -> void:
  game_manager = self


func _ready() -> void:
  _round_start_counter.count_end.connect(start_round)
  _end_message.exit_request.connect(on_exit_request)
  _pause_menu.exit_request.connect(on_exit_request)
  _pause_menu.continue_request.connect(on_continue_request)
  _pause_message.pause_request.connect(on_pause_request)


func start_game() -> void:
  var body_exited_signal : Signal = _game_area.body_exited
  if(body_exited_signal.is_connected(on_ball_exited) == false):
    body_exited_signal.connect(on_ball_exited)

  _enemy.set_target_ball(_ball)
  _score_manager.reset_score()
  _round_start_counter.start_counter()
  _pause_message.show_message()


func start_round() -> void:
  round_start.emit()


func on_pause_request() -> void:
  _pause_message.hide_message()
  get_tree().paused = true
  _pause_menu.show_menu()


func on_continue_request() -> void:
  _pause_menu.hide_menu()
  get_tree().paused = false
  _pause_message.show_message()


func on_exit_request() -> void:
  _pause_menu.hide_menu()
  get_tree().paused = false
  exit_game_request.emit()


func on_ball_exited(exited_ball: Ball) -> void:
  if(is_instance_valid(exited_ball) == false):
    return

  const DIR_TO_PLAYER : int = -1
  var exit_dir : int = int(signf(exited_ball.global_position.x))

  if(exit_dir == DIR_TO_PLAYER):
    #Metió Enemy
    _score_manager.enemy_scored()
  else:
    #Metió Player
    _score_manager.player_scored()

  match _score_manager.get_winner():
    ScoreManager.WINNER_TYPE.NONE:
      round_end.emit()
      _round_start_counter.start_counter()
    ScoreManager.WINNER_TYPE.PLAYER:
      game_end.emit()
      _end_message.show_message(EndMessage.END_STATE.WIN)
    ScoreManager.WINNER_TYPE.ENEMY:
      game_end.emit()
      _end_message.show_message(EndMessage.END_STATE.LOSE)
