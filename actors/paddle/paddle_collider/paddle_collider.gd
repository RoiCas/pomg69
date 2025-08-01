@tool
class_name PaddleCollider
extends StaticBody2D

const _MAX_PADDLE_SPEED : float = Common.UNIT_SIZE * 6.5

@export_category("REQUIRED")
@export var _coll_shape : CollisionShape2D = null

@export_category("VARS")
@export var _rect_size : Vector2i = Vector2i(16, 16):
  set(val):
    const MIN_SIZE : int = 1
    _rect_size = val.maxi(MIN_SIZE)

    if(is_instance_valid(_coll_shape) == true && _coll_shape.is_node_ready() == true):
      update_rect_shape()

var _current_speed : float = 0.0:
  set(val):
    _current_speed = clampf(val, -_MAX_PADDLE_SPEED, _MAX_PADDLE_SPEED)

func _ready() -> void:
  update_rect_shape()


func update_rect_shape() -> void:
  var rect_shape : RectangleShape2D = RectangleShape2D.new()
  rect_shape.size = _rect_size

  _coll_shape.shape = rect_shape


func get_bounce_angle() -> float:
  const MAX_ANGLE : float = PI / 4

  var bounce_angle : float = clampf(_current_speed / _MAX_PADDLE_SPEED, -1.0, 1.0)
  bounce_angle *= MAX_ANGLE

  return bounce_angle


func get_rect_size() -> Vector2:
  return _rect_size


func set_current_speed(new_speed: float) -> void:
  _current_speed = new_speed
