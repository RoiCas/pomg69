@tool
class_name Enemy
extends Paddle


@export_category("VARS")
@export_range(1, 10, 1, "suffix:UNITS") var _check_range : int = 5:
  set(val):
    _check_range = val
    if(Engine.is_editor_hint() == true):
      queue_redraw()

var _target_ball : Ball = null


func _ready() -> void:
  if(Engine.is_editor_hint() == true):
    set_physics_process(false)
    return

  super()


func _physics_process(delta: float) -> void:
  chase_ball(delta)


func set_target_ball(new_ball: Ball) -> void:
  _target_ball = new_ball


func chase_ball(delta: float) -> void:
  assert(_target_ball != null, "Missing target ball")

  var mov_dir : int = 0
  var half_vert_rect_size : float = _paddle_collider.get_rect_size().y / 2.0

  var diff_to_ball : float = _target_ball.global_position.y - global_position.y
  var dist_to_ball : float = absf(diff_to_ball)

  var hort_ball_dist : float = absf(_target_ball.global_position.x - global_position.x)
  var ball_in_range : bool = (hort_ball_dist <= _check_range * Common.UNIT_SIZE)


  if(ball_in_range == true):
    if(dist_to_ball > half_vert_rect_size):
      mov_dir = int(signf(diff_to_ball))
  else:
    if(dist_to_ball > half_vert_rect_size * 4.5):
      mov_dir = int(signf(diff_to_ball))


  move_paddle(mov_dir, delta)


func _draw() -> void:
  if(Engine.is_editor_hint() == false):
    return

  var origin : Vector2 = Vector2.ZERO
  var target : Vector2 = origin + Vector2.LEFT * _check_range * Common.UNIT_SIZE

  draw_line(origin, target, Color.RED, 3)
