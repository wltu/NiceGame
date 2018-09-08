extends Area2D

var num = ""

func _ready():
	num = self.name.substr(13, len(self.name))

func _process(delta):
	var bodies = self.get_overlapping_bodies()
	
	self.get_node("../../Doors/AutoDoor" + num).open = false
	
	for body in bodies:
#		print(body.name)
		if body.name == "Player" or body.name.find("Rock") != -1:
			self.get_node("../../Doors/AutoDoor" + num).open = true
			break
