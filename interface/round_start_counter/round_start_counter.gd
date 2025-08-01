class_name RoundStartCounter
extends CenterContainer

signal count_end()

@export_category("REQUIRED")
@export var _time_label : Label
@export var _start_timer : Timer

@export_category("VARS")
@export_range(1, 5, 1, "or_greater", "suffix:SECS") var _count_time : int = 3

func _ready() -> void:
  _start_timer.timeout.connect(on_start_timer_timeout)


func start_counter() -> void:
  _start_timer.start(_count_time)
  visible = true


func on_start_timer_timeout() -> void:
  count_end.emit()
  visible = false


func _process(_delta: float) -> void:
  if(_start_timer.is_stopped() == false):
    _time_label.text = secs_to_string(_start_timer.time_left)


func secs_to_string(secs: float) -> String:
  return str(int(secs + 1))
