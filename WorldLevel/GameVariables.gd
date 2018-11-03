extends Node

const GRAVITY = 20

const MONSTERS = ["Skeleton"]
var key = 0
var check_point = 0

var total_items = 2
var items = [0,0] #blocks, balls.
var prevous_item = [items[0], items[1]]
var prevous_key = 0

func save_state():
	prevous_item = [items[0], items[1]]
	prevous_key = key

func reset():
	items = prevous_item
	key = prevous_key 
	save_state()
