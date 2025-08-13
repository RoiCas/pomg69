class_name GameManager
extends Node

signal round_start()
signal round_end()
signal game_end()
signal exit_game_request()

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
  _round_start_counter.count_end.connect(on_count_end)

  _pause_message.pause_request.connect(on_pause_request)

  _pause_menu.restart_request.connect(on_restart_request)
  _pause_menu.exit_request.connect(on_exit_request)
  _pause_menu.continue_request.connect(on_continue_request)

  _end_message.restart_request.connect(on_restart_request)
  _end_message.exit_request.connect(on_end_message_exit_request)

  _game_area.body_exited.connect(on_ball_exited)


func start_game() -> void:
  reset_game()
  _round_start_counter.start_counter()


func on_count_end() -> void:
  start_round()


func start_round() -> void:
  round_start.emit()


func on_end_message_exit_request() -> void:
  exit_game_request.emit()


func on_restart_request() -> void:
  start_game()


func on_exit_request() -> void:
  get_tree().paused = false
  exit_game_request.emit()


func reset_game() -> void:
  round_end.emit()
  _score_manager.reset_score()
  _pause_menu.hide_menu()
  _end_message.hide_message()
  _pause_message.show_message()
  get_tree().paused = false


func on_pause_request() -> void:
  _pause_message.hide_message()
  get_tree().paused = true
  _pause_menu.show_menu()


func on_continue_request() -> void:
  _pause_menu.hide_menu()
  get_tree().paused = false
  _pause_message.show_message()


func on_ball_exited(ext_ball: Ball) -> void:
  if(is_instance_valid(ext_ball) == false || ext_ball.is_inside_tree() == false):
    return

  const PLAYER_DIR : int = -1
  var exit_dir : int = int(signf(ext_ball.global_position.x))

  if(exit_dir == PLAYER_DIR):
    #Metió Enemy
    _score_manager.enemy_scored()
  else:
    #Metió Player
    _score_manager.player_scored()


  var winner : int = _score_manager.get_winner()
  match winner:
    ScoreManager.WINNER_TYPE.PLAYER:
      _pause_message.hide_message()
      _end_message.show_message(EndMessage.END_STATE.WIN)
      game_end.emit()
    ScoreManager.WINNER_TYPE.ENEMY:
      _pause_message.hide_message()
      _end_message.show_message(EndMessage.END_STATE.LOSE)
      game_end.emit()
    ScoreManager.WINNER_TYPE.NONE:
      round_end.emit()
      _round_start_counter.start_counter()
