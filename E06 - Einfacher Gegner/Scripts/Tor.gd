extends Spatial

var respawn_pos
var is_current_checkpoint = false

func _ready():
	respawn_pos = $RespawnPoint.get_global_transform().origin

func _on_Area_body_entered(body):
	if body.has_method("set_checkpoint"):
		if !is_current_checkpoint:
			body.set_checkpoint(respawn_pos, self)
