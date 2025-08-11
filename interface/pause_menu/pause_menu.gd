class_name PauseMenu
extends CanvasLayer

signal exit_request()
signal continue_request()
signal restart_request()


@export_category("REQUIRED")
@export var _exit_button : Button
@export var _restart_button : Button
@export var _continue_button : Button


func _ready() -> void:
  _continue_button.pressed.connect(on_continue_button_pressed)
  _exit_button.pressed.connect(on_exit_button_pressed)
  _restart_button.pressed.connect(on_restart_button_pressed)

  hide_menu()



func show_menu() -> void:
  visible = true


func hide_menu() -> void:
  visible = false


func on_continue_button_pressed() -> void:
  continue_request.emit()


func on_exit_button_pressed() -> void:
  exit_request.emit()


func on_restart_button_pressed() -> void:
  restart_request.emit()
