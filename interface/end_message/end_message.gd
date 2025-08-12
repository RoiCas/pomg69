class_name EndMessage
extends CenterContainer

signal restart_request()
signal exit_request()

enum END_STATE {
  WIN = 0,
  LOSE = 1,
}

@export_category("REQUIRED")
@export var _end_label : Label
@export var _exit_button : Button
@export var _replay_button : Button


func _ready() -> void:
  _exit_button.pressed.connect(on_exit_pressed)
  _replay_button.pressed.connect(on_replay_pressed)

  visible = false


func show_message(state: END_STATE) -> void:
  match state:
    END_STATE.WIN:
      _end_label.text = "¡VICTORIA!"
    END_STATE.LOSE:
      _end_label.text = "QUE MAL..."
    _:
      assert(false, "Invalid state")

  visible = true


func hide_message() -> void:
  visible = false


func on_exit_pressed() -> void:
  exit_request.emit()

func on_replay_pressed() -> void:
  restart_request.emit()
  visible = false
