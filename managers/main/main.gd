class_name Main
extends Node

static var main : Main = null:
  set(val):
    assert(main == null, "Multiple Main")
    main = val


@export_category("REQUIRED")
@export var _start_screen : StartScreen

var _game_manager : GameManager = GameManager.new_game_manager()


func _init() -> void:
  Main.main = self


func _ready() -> void:
  connect_start_game_request()
  connect_exit_game_request()


func connect_exit_game_request() -> void:
  var exit_game_request : Signal = _game_manager.exit_game_request
  if(exit_game_request.is_connected(on_exit_to_title_request) == false):
    exit_game_request.connect(on_exit_to_title_request)


func connect_start_game_request() -> void:
  var start_game_request : Signal = _start_screen.start_game_request
  if(start_game_request.is_connected(on_start_game_request) == false):
    start_game_request.connect(on_start_game_request)


func on_start_game_request() -> void:
  remove_child(_start_screen)
  add_child(_game_manager)
  _game_manager.start_game()


func on_exit_to_title_request() -> void:
  remove_child(_game_manager)
  add_child(_start_screen)
