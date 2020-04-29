extends Position3D

onready var anim_player = $AnimationPlayer
var state = false # false = geschlossen und true = geöffnet

func open(hat_key):
	if hat_key:
		if !anim_player.is_playing():
			if state:
				anim_player.play_backwards("Öffnen")
				state = false
			
			else:
				anim_player.play("Öffnen")
				state = true
