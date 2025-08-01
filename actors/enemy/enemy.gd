class_name Enemy
extends Paddle

@export_category("VARS")
@export_range(1, 6, 1, "suffix:UNITS") var _check_range : int = 5

var _target_ball : Ball = null


func _ready() -> void:
  if(Engine.is_editor_hint() == true):
    set_physics_process(false)
    return

  super._ready()


func _physics_process(delta: float) -> void:
  chase_ball(delta)


func set_target_ball(new_ball: Ball) -> void:
  _target_ball = new_ball


func chase_ball(delta: float) -> void:
  assert(_target_ball != null, "Missing target ball")

  var ball_pos_diff : float = _target_ball.global_position.y - global_position.y
  var dist_to_ball : float = absf(ball_pos_diff)
  var mov_dir : int = 0

  var vert_rect_size : float = _paddle_collider.get_rect_size().y
  var ball_is_far : bool = absf(_target_ball.global_position.x - global_position.x) > (_check_range * Common.UNIT_SIZE)

  if(dist_to_ball > vert_rect_size / 2.0 && ball_is_far == false):
    mov_dir = int(signf(ball_pos_diff))


  move_paddle(mov_dir, delta)
