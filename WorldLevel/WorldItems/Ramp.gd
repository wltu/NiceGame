extends StaticBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
#
export (bool) var flip = false
var dir = 1


func _ready():
	if flip:
		dir = -1
		$Sprite.flip_h = true
		$Right.disabled = true
		$Left.disabled = false
		$Area2D/Right.disabled = true
		$Area2D/Left.disabled = false
		

func _physics_process(delta):
	var bodies = $Area2D.get_overlapping_bodies()
	
	for body in bodies:
		if body.get_class() == "KinematicBody2D":
			body.motion.x += 5*dir