@tool
extends EditorPlugin


const Main := preload("res://addons/godot_style/main.tscn")


var main_instance: Control


func _enter_tree() -> void:
	# Initialization of the plugin goes here.
	main_instance = Main.instantiate()
	
	get_editor_interface().get_editor_main_screen().add_child(main_instance)
	_make_visible(false)
	return


func _exit_tree() -> void:
	# Clean-up of the plugin goes here.
	if main_instance:
		main_instance.queue_free()
	return

func _has_main_screen() -> bool:
	return true
	
	
func _make_visible(visible: bool) -> void:
	if main_instance:
		main_instance.visible = visible
	return
	
	
func _get_plugin_name() -> String:
	return "Style"
	
	
func _get_plugin_icon() -> Texture2D:
	return get_editor_interface().get_base_control().get_theme_icon("Script", "EditorIcons")
