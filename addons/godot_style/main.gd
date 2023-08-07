@tool
#class_name
extends Control

## Main UI of the addon

## Preloading section.tscn into a PackedScene ready to be instantiated
const SectionUI := preload("res://addons/godot_style/section.tscn")

## Sections of type SectionResource to be displayed
@export var sections: Array[SectionResource]

@onready var sections_container: VBoxContainer = $HBoxContainer/NavigationTrees/SectionsContainer


func _ready() -> void:
	# Adding sections to container
	for section in sections:
		var section_ui := SectionUI.instantiate()
		sections_container.add_child(section_ui) ## Ensuring tree is ready
		
		section_ui.tree.item_selected.connect(
			_on_SectionUI_Tree_item_selected.bind(section_ui.tree)
			# Pass in the corresponding Tree to have access to the correct selected item
		)
		
		section_ui.tree.add_to_group("trees")
		section_ui.display(section)
		
	# Selecting the first item in first run
	var first_section_ui := sections_container.get_child(0)
	first_section_ui.tree.set_selected(
		first_section_ui.tree.get_root().get_first_child(),
		0
	)
	return


func _on_SectionUI_Tree_item_selected(tree: Tree) -> void:
	var selected_tree_item: TreeItem = tree.get_selected()
	var item: ItemResource = selected_tree_item.get_metadata(0) # This was set in the display() function
	
	# De-selecting items in other trees
	for tr in get_tree().get_nodes_in_group("trees"):
		if tr == tree:
			continue
		tr.deselect_all()
	
	%ItemName.text = item.name
	
	# Deleting existing pictures
	for child in %Pictures.get_children():
		%Pictures.remove_child(child)
		child.queue_free()
		
	# Adding new pictures of selected item
	for picture in item.pictures:
		var texture_rect := TextureRect.new()
		texture_rect.expand_mode = TextureRect.EXPAND_KEEP_SIZE
		texture_rect.stretch_mode = TextureRect.STRETCH_KEEP
		texture_rect.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		texture_rect.size_flags_vertical = Control.SIZE_EXPAND_FILL
		
		texture_rect.texture = picture
		%Pictures.add_child(texture_rect)
	return
