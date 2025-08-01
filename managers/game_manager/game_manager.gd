class_name GameManager
extends Node

signal round_start()
signal round_end()
signal game_end()

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


func _init() -> void:
  game_manager = self


func _ready() -> void:
  _round_start_counter.count_end.connect(start_round)

  start_game()


func start_game() -> void:
  if(_game_area.body_exited.is_connected(on_ball_exited) == false):
    _game_area.body_exited.connect(on_ball_exited)

  _enemy.set_target_ball(_ball)
  _score_manager.reset_score()
  _round_start_counter.start_counter()


func start_round() -> void:
  round_start.emit()


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
