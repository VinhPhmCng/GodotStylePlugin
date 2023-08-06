@tool
#class_name
extends Control

# docstring


#################################################
#___________________ SIGNALS ___________________#
#################################################




#################################################
#____________________ ENUMS ____________________#
#################################################




#################################################
#__________________ CONSTANTS __________________#
#################################################

const SectionUI := preload("res://addons/godot_style/section.tscn")


#################################################
#______________ EXPORTED VARIABLES _____________#
#################################################

@export var sections: Array[SectionResource]


#################################################
#_______________ PUBLIC VARIABLES ______________#
#################################################




#################################################
#_______________ PRIVATE VARIABLES _____________#
#################################################




#################################################
#______________ ONREADY VARIABLES ______________#
#################################################

@onready var sections_container: VBoxContainer = $HBoxContainer/NavigationTrees/SectionsContainer



#################################################
#___________________ _init() ___________________#
#################################################


#################################################
#________________ _enter_tree() ________________#
#################################################


#################################################
#___________________ _ready() __________________#
#################################################

func _ready() -> void:
	# Adding sections to container
	for section in sections:
		var section_ui := SectionUI.instantiate()
		sections_container.add_child(section_ui)
		
		section_ui.tree.item_selected.connect(
			_on_SectionUI_Tree_item_selected.bind(section_ui.tree)
		)
		
		section_ui.tree.add_to_group("trees")
		
		section_ui.display(section)
		
	# Selecting the first item
	var first_section_ui := sections_container.get_child(0)
	first_section_ui.tree.set_selected(
		first_section_ui.tree.get_root().get_first_child(),
		0
	)
	return



#################################################
#_______________ VIRTUAL METHODS _______________#
#################################################




#################################################
#________________ PUBLIC METHODS _______________#
#################################################




#################################################
#________________ PRIVATE METHODS ______________#
#################################################

func _on_SectionUI_Tree_item_selected(tree: Tree) -> void:
	var selected_tree_item: TreeItem = tree.get_selected()
	var item: ItemResource = selected_tree_item.get_metadata(0)
	
	# De-selecting other trees
	for tr in get_tree().get_nodes_in_group("trees"):
		if tr == tree:
			continue
		tr.deselect_all()
	
	# Item name
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


#################################################
#_______________ SIGNAL CALLBACKS ______________#
#################################################

#_______________________________________________#
#__________________ INTERNAL ___________________#
#_______________________________________________#

#_______________________________________________#
#__________________ EXTERNAL ___________________#
#_______________________________________________#


