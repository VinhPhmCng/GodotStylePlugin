@tool
class_name ItemResource
extends Resource
## Custom class to create new Items for Sections.[br]
## [br]
## I have no idea how to implement markdown in Godot yet,
## so I'll just use pictures for now lmao.

## Will be used to navigate in the Tree and as a title in [code]Main/ItemContent/ItemName[/code] 
@export var name: String = "Name"

## Pictures of type Texture2D to be displayed when this Item is selected.
@export var pictures: Array[Texture2D]
