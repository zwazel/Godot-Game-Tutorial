extends Area

func _on_Schlssel_body_entered(body):
	body.hat_key = true
	queue_free()
