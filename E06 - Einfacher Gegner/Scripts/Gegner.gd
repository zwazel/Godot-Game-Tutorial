extends KinematicBody

export var MOVE_SPEED = 3;
var alerted = false

onready var raycast = $Augen/RayCast;

var player = null; #The player / Our target

func _ready():
	add_to_group("gegner");

func set_player(p):
	player = p

func _physics_process(delta):
	if player == null: #If the player does not exist, dont do anything.
		return;
	
	if alerted:
		var vec_to_player = player.translation - translation; #Get a vector pointing to the player
		vec_to_player = vec_to_player.normalized(); #Normalize the vector
		move_and_collide(vec_to_player * MOVE_SPEED * delta); #Move along the vector
		
		look_at(player.get_transform().origin, Vector3(0,1,0))
		rotation_degrees.x = 0
		rotation_degrees.z = 0
		
	if raycast.is_colliding():
		var coll = raycast.get_collider();
		if coll.has_method("kill") and coll.name == "Spieler":
			coll.kill();

func _on_Area_body_entered(body):
	if body.name == "Spieler":
		alerted = true

func _on_Area_body_exited(body):
	if body.name == "Spieler":
		alerted = false
