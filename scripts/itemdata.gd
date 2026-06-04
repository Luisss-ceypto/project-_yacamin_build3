extends Resource
class_name ItemData

@export var nome_item : String
@export var icon: Texture2D = preload("res://icon.svg")
@export var mesh_scene: PackedScene
@export var interactable_scene : PackedScene = preload("res://assets/bau e itens/interativo.tscn")
