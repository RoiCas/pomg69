class_name Paddle
extends CharacterBody2D

@export_category("REQUIRED")
@export var _paddle_collider : PaddleCollider

@export_category("VARS")
##UNIDADES / SEG
@export_range(1.0, 20.0, 0.1, "or_greater", "suffix:U/S") var _speed : float = 13.5
@export_range(0.01, 1.0, 0.01, "or_greater", "suffix:secs") var _accel_secs : float = 0.12

@onready var _init_pos : Vector2 = self.global_position

var _can_move : bool = false

##Override.
##Se debe hacer super._ready() si se vuelve a implementar.
func _ready() -> void:
  GameManager.game_manager.round_end.connect(on_round_end)
  GameManager.game_manager.round_start.connect(on_round_start)


func move_paddle(move_dir: int, delta: float) -> void:
  if(_can_move == false):
    return

  velocity.y += (((move_dir * _speed * Common.UNIT_SIZE) - velocity.y) / _accel_secs) * delta
  var collision : KinematicCollision2D = move_and_collide(velocity * delta)
  if(collision != null):
    reset_velocity()

  _paddle_collider.set_current_speed(velocity.y)


func reset_velocity() -> void:
  velocity = Vector2.ZERO


func on_round_start() -> void:
  _can_move = true


func on_round_end() -> void:
  global_position = _init_pos
  reset_velocity()
  _can_move = false
