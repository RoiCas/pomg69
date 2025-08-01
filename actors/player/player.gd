class_name Player
extends Paddle


const _ACCEL_SECS : float = 0.12


func _physics_process(delta: float) -> void:
  var move_dir : int = int(signf(Input.get_axis(&"Y_POS", &"Y_NEG")))

  move_paddle(move_dir, _ACCEL_SECS, delta)
