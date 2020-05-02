extends Area

func _on_Lava_body_entered(body):
	if body.has_method("kill"):
		body.kill()
