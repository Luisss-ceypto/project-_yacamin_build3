extends Node

signal inventory_change
signal slot_selected(slot_index: int)
signal item_drop(item)


var hotbar_size := 4
var hotbar: Array[ItemData]
var selected_slot: int = 0

func _init() -> void:
	for i in hotbar_size:
		hotbar.append(null)
		


func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_pressed():
		if event.keycode == KEY_F:
			drop_item(selected_slot)


func add_item(item: ItemData)-> bool:
	for i in hotbar_size:
		if hotbar[i] == null:
			hotbar[i] = item
			inventory_change.emit()
			slot_selected.emit(i)
			return true
	return false


func select_slot(index: int):
	print(index)
	selected_slot = clamp(index, 0, hotbar_size - 1)
	slot_selected.emit(selected_slot)


func spawn_item(item: ItemData):
	var interactable = item.interactable_scene.instantiate()
	interactable.item_data = item
	get_tree().current_scene.add_child(interactable)
	item_drop.emit(interactable)


func drop_item(slot_index: int):
	if hotbar[slot_index]:
		var droped_item = hotbar[slot_index]
		spawn_item(droped_item)
		hotbar[slot_index] = null
		inventory_change.emit()
		if slot_index == selected_slot:
			slot_selected.emit(selected_slot)
