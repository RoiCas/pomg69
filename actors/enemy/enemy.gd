class_name Enemy
extends Paddle

var _target_ball : Ball = null


func _physics_process(delta: float) -> void:
  chase_ball(delta)


func set_target_ball(new_ball: Ball) -> void:
  _target_ball = new_ball


func chase_ball(delta: float) -> void:
  assert(_target_ball != null, "Missing target ball")

  var mov_dir : int = int(signf(_target_ball.global_position.y - global_position.y))

  move_paddle(mov_dir, delta)
