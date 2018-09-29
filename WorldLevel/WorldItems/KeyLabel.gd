extends Label

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	self.text = "0";
	pass

func _process(delta):
	self.text = str(GameVariables.key);
