class_name GameManagerSM
extends Node

enum GameState{
  WAIT_ROUND = 0,
  PLAY = 1,
  PAUSE = 2,
  GAME_OVER = 3,
}

@onready var _game_manager : GameManager = self.owner as GameManager

var _current_state : GameState = GameState.WAIT_ROUND


func _ready() -> void:
  assert(_game_manager != null, "Missing GameManager")

  connect_signals()


func connect_signals() -> void:
  _game_manager.start_game_request.connect(on_start_game)
  _game_manager.start_round_request.connect(on_start_round)
  _game_manager.pause_request.connect(on_pause_game)
  _game_manager.continue_request.connect(on_continue_game)
  _game_manager.reset_request.connect(on_reset_game)
  _game_manager.restart_request.connect(on_restart_game)
  _game_manager.end_game_request.connect(on_end_game)
  _game_manager.ball_exited_request.connect(on_ball_exited)


func update_state(new_state: GameState) -> void:
  _current_state = new_state

  match _current_state:
    GameState.WAIT_ROUND:
      get_tree().paused = false
      _game_manager.show_pause_message()
      _game_manager.start_round_counter()
    GameState.PLAY:
      get_tree().paused = false
      _game_manager.hide_pause_message()
      _game_manager.round_start.emit()
    GameState.PAUSE:
      get_tree().paused = true
      _game_manager.show_pause_menu()
    GameState.GAME_OVER:
      get_tree().paused = false
      _game_manager.game_end.emit()


func on_start_game() -> void:
  update_state(GameState.WAIT_ROUND)


func on_start_round() -> void:
  update_state(GameState.PLAY)


func on_pause_game() -> void:
  update_state(GameState.PAUSE)


func on_continue_game() -> void:
  update_state(GameState.PLAY)


func on_reset_game() -> void:
  update_state(GameState.WAIT_ROUND)


func on_restart_game() -> void:
  update_state(GameState.WAIT_ROUND)


func on_end_game() -> void:
  update_state(GameState.GAME_OVER)


func on_ball_exited(winner_type: int) -> void:
  match winner_type:
    ScoreManager.WINNER_TYPE.NONE:
      update_state(GameState.WAIT_ROUND)
    ScoreManager.WINNER_TYPE.PLAYER:
      update_state(GameState.GAME_OVER)
    ScoreManager.WINNER_TYPE.ENEMY:
      update_state(GameState.GAME_OVER)
