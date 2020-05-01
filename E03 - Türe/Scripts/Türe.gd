extends StaticBody

var rotatePoint
var anim_player
var state = false # true = offen, false = geschlossen

func _ready():
	rotatePoint = get_parent().get_parent()
	anim_player = rotatePoint.get_child(0)

func open_door(hat_key):
	if hat_key:
		if !anim_player.is_playing():
			if state:
				anim_player.play_backwards("Öffnen")
				state = false
			else:
				anim_player.play("Öffnen")
				state = true
