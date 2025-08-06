class_name PauseMessage
extends CenterContainer

signal pause_request()


@export_category("REQUIRED")
@export var _pause_button : Button


func _ready() -> void:
  _pause_button.pressed.connect(on_pause_button_pressed)


func hide_message() -> void:
  visible = false


func show_message() -> void:
  visible = true


func on_pause_button_pressed() -> void:
  pause_request.emit()
