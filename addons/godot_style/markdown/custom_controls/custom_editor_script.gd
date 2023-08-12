@tool
extends EditorScript

var script_editor: ScriptEditor
var current_editor: ScriptEditorBase
var code_edit: CodeEdit

func _init() -> void:
	script_editor = get_editor_interface().get_script_editor()
	current_editor = script_editor.get_current_editor()
	code_edit = current_editor.get_base_editor()
	return
	
	
func get_godot_syntax_highlighter() -> SyntaxHighlighter:
	print("CustomEditorScript")
	print(code_edit)
	print(code_edit.get_syntax_highlighter())
	print("_______________________________")
	return code_edit.get_syntax_highlighter()
