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


func connect_start_game_request() -> void:
  var start_game_request : Signal = _start_screen.start_game_request
  if(start_game_request.is_connected(on_start_game_request) == false):
    start_game_request.connect(on_start_game_request)


func on_start_game_request() -> void:
  #TODO
  pass


func on_exit_to_title_request() -> void:
  #TODO
  pass
