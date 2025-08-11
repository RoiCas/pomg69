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


func update_state(new_state: GameState) -> void:
  _current_state = new_state

  match _current_state:
    GameState.WAIT_ROUND:
      get_tree().paused = false
      _game_manager.show_pause_message()
      _game_manager._round_start_counter.start_counter()
    GameState.PLAY:
      get_tree().paused = false
      _game_manager.hide_pause_menu()
      _game_manager.round_start.emit()
    GameState.PAUSE:
      get_tree().paused = true
      _game_manager.show_pause_menu()
    GameState.GAME_OVER:
      get_tree().paused = false
      _game_manager.game_end.emit()
