extends Spatial

onready var respawn_pos = $respawnPoint.get_global_transform().origin
var is_current_checkpoint = false

func _on_Area_body_entered(body):
	if !is_current_checkpoint:
		if body.has_method("set_checkpoint"):
			body.set_checkpoint(respawn_pos, self)
