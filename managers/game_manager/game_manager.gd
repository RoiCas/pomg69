class_name GameManager
extends Node

signal round_start()
signal round_end()
signal game_end()
signal exit_game_request()

signal start_game_request()
signal end_game_request()
signal restart_request()
signal reset_request()
signal continue_request()
signal pause_request()
signal start_round_request()
signal ball_exited(winner_type: int)

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
  connect_signals()

  _enemy.set_target_ball(_ball)


func connect_signals() -> void:
  _round_start_counter.count_end.connect(start_round)
  _end_message.exit_request.connect(on_exit_request)
  _pause_menu.exit_request.connect(on_exit_request)
  _pause_menu.continue_request.connect(on_continue_request)
  _pause_message.pause_request.connect(on_pause_request)
  _end_message.restart_request.connect(on_restart_request)
  _pause_menu.restart_request.connect(on_restart_request)
  _game_area.body_exited.connect(on_ball_exited)


func start_game() -> void:
  start_game_request.emit()


func start_round() -> void:
  start_round_request.emit()


func show_pause_message() -> void:
  _pause_message.show_message()


func hide_pause_message() -> void:
  _pause_message.hide_message()


func show_pause_menu() -> void:
  _pause_menu.show_menu()


func hide_pause_menu() -> void:
  _pause_menu.hide_menu()


func start_round_counter() -> void:
  _round_start_counter.start_counter()


func on_pause_request() -> void:
  hide_pause_message()
  pause_request.emit()


func on_continue_request() -> void:
  hide_pause_menu()
  continue_request.emit()


func on_exit_request() -> void:
  hide_pause_menu()
  reset_game()
  exit_game_request.emit()


func reset_game() -> void:
  round_end.emit()
  _score_manager.reset_score()
  reset_request.emit()


func on_restart_request() -> void:
  hide_pause_menu()
  restart_request.emit()


func end_game(winner_type: int) -> void:
  end_game_request.emit()

  match winner_type:
    ScoreManager.WINNER_TYPE.PLAYER:
      _end_message.show_message(EndMessage.END_STATE.WIN)
    ScoreManager.WINNER_TYPE.ENEMY:
      _end_message.show_message(EndMessage.END_STATE.LOSE)


func on_ball_exited(ex_ball: Ball) -> void:
  if(is_instance_valid(ex_ball) == false || _round_start_counter.is_inside_tree() == false):
    return

  const DIR_TO_PLAYER: int = -1
  var exit_dir : int = int(signf(ex_ball.global_position.x))

  if(exit_dir == DIR_TO_PLAYER):
    _score_manager.enemy_scored()
  else:
    _score_manager.player_scored()

  var winner_type: int = _score_manager.get_winner()
  ball_exited.emit(winner_type)
