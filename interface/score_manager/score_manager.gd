class_name ScoreManager
extends Control

enum WINNER_TYPE {
  NONE = 0,
  PLAYER = 1,
  ENEMY = 2,
}

@export_category("REQUIRED")
@export var _player_score_label : Label
@export var _enemy_score_label : Label

@export_category("VARS")
@export_range(1, 16, 1, "suffix:points") var _max_score : int = 16

var _player_score : int = 0
var _enemy_score : int = 0


func reset_score() -> void:
  _player_score = 0
  _enemy_score = 0

  _player_score_label.text = score_to_string(_player_score)
  _enemy_score_label.text = score_to_string(_enemy_score)


func player_scored() -> void:
  _player_score += 1
  _player_score_label.text = score_to_string(_player_score)


func enemy_scored() -> void:
  _enemy_score += 1
  _enemy_score_label.text = score_to_string(_enemy_score)


func score_to_string(score: int) -> String:
  var score_string : String = ""
  @warning_ignore("integer_division")
  var tens : int = score / 10
  var units : int = score % 10

  score_string = str(tens, units)
  return score_string


func get_winner() -> WINNER_TYPE:
  if(_player_score >= _max_score):
    return WINNER_TYPE.PLAYER
  elif(_enemy_score >= _max_score):
    return WINNER_TYPE.ENEMY

  return WINNER_TYPE.NONE
