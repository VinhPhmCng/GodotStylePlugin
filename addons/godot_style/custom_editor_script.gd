@tool
extends EditorScript

var editor_interface: EditorInterface
var script_editor: ScriptEditor
var current_editor: ScriptEditorBase
var code_edit: CodeEdit

func _init() -> void:
	return
	
	
func get_godot_syntax_highlighter() -> SyntaxHighlighter:
	editor_interface = get_editor_interface()
	if editor_interface:
		script_editor = editor_interface.get_script_editor()
	if script_editor:
		current_editor = script_editor.get_current_editor()
	if current_editor:
		code_edit = current_editor.get_base_editor()
	if code_edit:
		return code_edit.get_syntax_highlighter()
	
	push_warning("Godot Style: custom_editor_script.gd failed to get_godot_syntax_highlighter(). Check Section 'Issues'.")
	return SyntaxHighlighter.new()
