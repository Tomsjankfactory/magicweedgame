class_name InventorySlot
extends Node

var item : Item
var quantity : int

@onready var icon : TextureRect = get_node("Icon")
@onready var quantity_text : Label = get_node("QuantityText")

var inventory : Inventory

func set_item(new_item : Item):
	pass

func add_item():
	pass

func remove_item():
	pass

func update_quantity_text():
	pass
