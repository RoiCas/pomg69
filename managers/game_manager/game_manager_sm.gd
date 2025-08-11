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
  _game_manager.start_game_request.connect(on_start_game_request)


func update_state(new_state: GameState) -> void:
  _current_state = new_state

  match _current_state:
    GameState.WAIT_ROUND:
      get_tree().paused = false
      _game_manager.show_pause_message()
      _game_manager.start_round_counter()
    GameState.PLAY:
      get_tree().paused = false
      _game_manager.hide_pause_menu()
      _game_manager.show_pause_message()
      _game_manager.round_start.emit()
    GameState.PAUSE:
      get_tree().paused = true
      _game_manager.show_pause_menu()
    GameState.GAME_OVER:
      get_tree().paused = false
      _game_manager.game_end.emit()


func on_start_game_request() -> void:
  update_state(GameState.WAIT_ROUND)


func on_ball_exited(winner_type: int) -> void:
  match winner_type:
    ScoreManager.WINNER_TYPE.NONE:
      update_state(GameState.WAIT_ROUND)
    ScoreManager.WINNER_TYPE.PLAYER:
      update_state(GameState.GAME_OVER)
    ScoreManager.WINNER_TYPE.ENEMY:
      update_state(GameState.GAME_OVER)
