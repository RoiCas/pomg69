class_name Ball
extends CharacterBody2D


const _INIT_SPEED : float = Common.UNIT_SIZE * 8.5

#Solo se define una vez. Al inicio
@onready var _init_pos : Vector2 = self.global_position

var _current_speed : float = 0.0
var _move_dir : Vector2 = Vector2():
  set(val):
    _move_dir = val.normalized()


func _unhandled_input(event: InputEvent) -> void:
  if(event.is_action_pressed("ui_accept") == true):
    _move_dir = Vector2.LEFT
    reset_speed()


func _ready() -> void:
  GameManager.game_manager.round_end.connect(on_round_end)
  GameManager.game_manager.round_start.connect(on_round_start)


func _physics_process(delta: float) -> void:
  move_ball(delta)


func move_ball(delta: float) -> void:
  velocity = _move_dir * _current_speed
  var collision : KinematicCollision2D = move_and_collide(velocity * delta, delta)
  if(collision != null):
    handle_collision(collision)

  velocity = _move_dir * _current_speed
  move_and_collide(velocity * delta)


func handle_collision(collision: KinematicCollision2D) -> void:
  var paddle_collider : PaddleCollider = collision.get_collider() as PaddleCollider
  var coll_normal : Vector2 = collision.get_normal()

  if(paddle_collider == null):
    #Chocamos con pared
    var bounce_dir : Vector2 = _move_dir.bounce(coll_normal)
    bounce_ball(bounce_dir)
    return

  #Chocamos con el paddle
  var dir_to_collision : int = int(signf(paddle_collider.global_position.x))
  var bounce_direction : Vector2 = Vector2(-dir_to_collision, 0.0)
  var bounce_angle : float = paddle_collider.get_bounce_angle()
  var bounce_dot_prod : float = bounce_direction.dot(coll_normal)

  if(bounce_dot_prod < 0.9):
    reposition_ball(paddle_collider, int(bounce_direction.x))

  bounce_direction = bounce_direction.rotated(bounce_angle * bounce_direction.x)

  bounce_dot_prod = bounce_direction.dot(coll_normal)
  if(bounce_dot_prod > 0.9):
    const BOUNCE_NOISE : float = PI / 8
    var noise_angle : float = randf_range(-BOUNCE_NOISE, BOUNCE_NOISE)

    bounce_direction = bounce_direction.rotated(noise_angle * bounce_direction.x)


  bounce_ball(bounce_direction)


func reposition_ball(paddle_coll: PaddleCollider, hort_bounce_dir: int) -> void:
  const SAFE_DIST : float = 8.0
  var half_hort_rect : float = paddle_coll.get_rect_size().x / 2.0
  global_position.x = paddle_coll.global_position.x + ((half_hort_rect + SAFE_DIST) * hort_bounce_dir)


func bounce_ball(new_dir: Vector2) -> void:
  _move_dir = new_dir


func reset_speed() -> void:
  _current_speed = _INIT_SPEED


func on_round_start() -> void:
  pass


func on_round_end() -> void:
  reset_speed()
  _move_dir = Vector2.ZERO
  global_position = _init_pos
