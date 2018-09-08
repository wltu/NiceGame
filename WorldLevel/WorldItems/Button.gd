extends Sprite

var num = ""
var toggled = false

func _ready():
	num = self.name.substr(6, len(self.name))
	

func _physics_process(delta):
	
	if !toggled:
		var bodies = $Area2D.get_overlapping_bodies()
		
		for body in bodies:
			if body.name == "Player" or body.name.find("Ball") != -1:
				self.scale = Vector2(1, 0.5)
				
				self.get_node("../../Doors/ButtonDoor" + num).open = true
				break
	