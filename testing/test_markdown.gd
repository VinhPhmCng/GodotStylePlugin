#@tool
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

const Markdown := preload("res://addons/godot_style/markdown/markdown_implementation.gd")


#################################################
#______________ EXPORTED VARIABLES _____________#
#################################################

@export_file("*.md") var path: String


#################################################
#_______________ PUBLIC VARIABLES ______________#
#################################################




#################################################
#_______________ PRIVATE VARIABLES _____________#
#################################################




#################################################
#______________ ONREADY VARIABLES ______________#
#################################################




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
	var file := FileAccess.open(path, FileAccess.READ)
	var content = file.get_as_text()
	
	%Markdown.text = content
	
	var markdown_helper := Markdown.new()
	var converted: String = markdown_helper._test_add_md_to_container(content)
	%BBCode.text = converted
	
	var save_file := FileAccess.open("res://testing/save.txt", FileAccess.WRITE)
	save_file.store_string(converted)
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




#################################################
#_______________ SIGNAL CALLBACKS ______________#
#################################################

#_______________________________________________#
#__________________ INTERNAL ___________________#
#_______________________________________________#

#_______________________________________________#
#__________________ EXTERNAL ___________________#
#_______________________________________________#


