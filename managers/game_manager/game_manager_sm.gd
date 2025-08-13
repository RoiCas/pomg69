class_name GameManagerSM
extends Node

@export_category("REQUIRED")
@export var _game_manager : GameManager


enum GameState {
  IDLE = 0,
  COUNT_DOWN = 1,
  PLAY = 2,
  PAUSE = 3,
  GAME_OVER = 4,
}


var _current_state : GameState = GameState.IDLE


func update_state(new_state: GameState) -> void:
  if(new_state != _current_state):
    exit_state()

    _current_state = new_state
    enter_state()


func enter_state() -> void:
  pass

func exit_state() -> void:
  pass
