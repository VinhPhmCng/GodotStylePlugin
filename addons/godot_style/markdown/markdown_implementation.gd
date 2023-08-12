@tool
#class_name
extends Resource

# Use RichTextLabel:
# Bold, italic, strikethrough texts
# Headings
# Lists
# Quoting inline codes
# Links
# Images
# Comments

# Use other Controls:
# Quoting texts (Label)
# Quoting code blocks (TextEdit)

# Might implement:
# Nested lists (BBCode's [indent] tag?)
# Alerts (Custom Control?)

# Won't implement yet:
# Supported color models
# Section links
# Relative links
# Specifying the theme an image is shown to
# Task lists
# Mentioning people and teams
# Referencing issues and pull requests
# Uploading assets
# Using emoji
# Footnotes


#################################################
#___________________ SIGNALS ___________________#
#################################################




#################################################
#____________________ ENUMS ____________________#
#################################################




#################################################
#__________________ CONSTANTS __________________#
#################################################

const MarkdownRTL := preload("res://addons/godot_style/markdown/custom_controls/markdown_rtl.tscn")
const CodeBlock := preload("res://addons/godot_style/markdown/custom_controls/code_block.tscn")
const LevelOneHeading := preload("res://addons/godot_style/markdown/custom_controls/level_one_heading.tscn")
const LevelTwoHeading := preload("res://addons/godot_style/markdown/custom_controls/level_two_heading.tscn")
const LevelThreeHeading := preload("res://addons/godot_style/markdown/custom_controls/level_three_heading.tscn")
const QuoteControl := preload("res://addons/godot_style/markdown/custom_controls/quote.tscn")

# Colors
# Reference for quick Search and replace all
const bgcolor_inline_code := "#343942"
const color_link := "#2c77e3"

#################################################
#______________ EXPORTED VARIABLES _____________#
#################################################




#################################################
#_______________ PUBLIC VARIABLES ______________#
#################################################

var gdscript_syntax_highlighter: SyntaxHighlighter


#################################################
#_______________ PRIVATE VARIABLES _____________#
#################################################

var _is_code_block := false
var _code_block_stack:  PackedStringArray = []
var _bbcode_stack: PackedStringArray = []
var _md_viewer: VBoxContainer

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
	pass


#################################################
#_______________ VIRTUAL METHODS _______________#
#################################################




#################################################
#________________ PUBLIC METHODS _______________#
#################################################

func create_text_file_viewer(path: String) -> VBoxContainer:
	var file := FileAccess.open(path, FileAccess.READ)
	if not file:
		push_error("Cannot open file: " + "\"" + path + "\"")
		return null
	var content = file.get_as_text()
	
	if path.ends_with(".md"):
		return _create_md_viewer(content)
	return _create_txt_viewer(content)


#################################################
#________________ PRIVATE METHODS ______________#
#################################################

func _create_txt_viewer(content: String) -> VBoxContainer:
	return


func _create_md_viewer(content: String) -> VBoxContainer:
	var viewer := VBoxContainer.new()
	# Settings
	viewer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	viewer.size_flags_vertical = Control.SIZE_EXPAND_FILL
	
	# For every line, detect Headings, Quotes and Code Blocks
	# deal with those
	# and keep everything in order
	var lines := content.split("\n")
	for line in lines: # Looping through every line of content
		if line.begins_with("```"):
			if not _is_code_block:
				_add_bbcode_stack(viewer)
				_is_code_block = true
				continue
			else:
				_add_code_block(viewer)
				_is_code_block = false
				continue
		if _is_code_block:
			_stack_code_block(line)
			continue
		if line.begins_with("### "):
			_add_bbcode_stack(viewer)
			_add_heading_3(line.right(-4), viewer)
			continue
		if line.begins_with("## "):
			_add_bbcode_stack(viewer)
			_add_heading_2(line.right(-3), viewer)
			continue
		if line.begins_with("# "):
			_add_bbcode_stack(viewer)
			_add_heading_1(line.right(-2), viewer)
			continue
		if line.begins_with(">"):
			_add_bbcode_stack(viewer)
			_add_quote(line.right(-1), viewer)
			continue
		_stack_bbcode(line)
		continue
	
	# Adding the remaining
	if _bbcode_stack.size():
		_add_bbcode_stack(viewer)
	if _code_block_stack.size():
		_add_code_block(viewer)
	return viewer


func _stack_bbcode(line: String) -> void:
	_bbcode_stack.append(line)
	return


func _add_bbcode_stack(container: VBoxContainer) -> void:
	var rt_label := MarkdownRTL.instantiate()
	rt_label.text = "\n".join(_bbcode_stack)
	rt_label.text = _markdown_to_bbcode(rt_label.text)
	container.add_child(rt_label)
	
#	printt(_bbcode_stack, "\n".join(_bbcode_stack))
	_bbcode_stack.clear()
	return


func _stack_code_block(line: String) -> void:	
	_code_block_stack.append(line)
	return


func _add_code_block(container: VBoxContainer) -> void:
	var code_block := CodeBlock.instantiate()
	code_block.set_deferred("text", "\n".join(_code_block_stack))
	
	if gdscript_syntax_highlighter:
		code_block.set_syntax_highlighter(gdscript_syntax_highlighter)
	else:
		push_warning("No SyntaxHighlighter")
	
	container.add_child(code_block)
	
	_code_block_stack.clear()
	return


func _add_heading_1(text: String, container: VBoxContainer) -> void:
	var label := LevelOneHeading.instantiate()
	text = _convert_styling(text)
	label.text = text
	container.add_child(label)
	return


func _add_heading_2(text: String, container: VBoxContainer) -> void:
	var label := LevelTwoHeading.instantiate()
	text = _convert_styling(text)
	label.text = text
	container.add_child(label)
	return
	
	
func _add_heading_3(text: String, container: VBoxContainer) -> void:
	var label := LevelThreeHeading.instantiate()
	text = _convert_styling(text)
	label.text = text
	container.add_child(label)
	return


func _add_quote(text: String, container: VBoxContainer) -> void:
	var hbox_container := QuoteControl.instantiate()
	var label := hbox_container.get_node("%Quote")
	text = _convert_styling(text)
	label.text = text
	container.add_child(hbox_container)
	return


func _markdown_to_bbcode(md: String) -> String:
	var content = md
	content = _convert_styling(content)
	content = _convert_image(content)
	content = _convert_link(content)
	content = _convert_unordered_list(content)
	
	# Ordered lists
#	regex.compile("[1-9]+.\\s(?<item>.*)")
#	content = regex.sub(content, "[ol type=1]${item}[/ol]", true)
#	content = _convert_ordered_list(content)
	
	# Indenting
	for _i in range(5): # I hope nobody indents more than 5 levels lol
		content = _convert_indentation(content)
		
	return content


# Regex
func _convert_bolded(md: String) -> String:
	var regex := RegEx.new()
	regex.compile("\\*\\*(?<bolded>[^*\\n]+?)\\*\\*")
	return regex.sub(md, "[b]${bolded}[/b]", true)


func _convert_italics(md: String) -> String:
	var regex := RegEx.new()
	regex.compile("\\*(?<italics>[^*\\n]+?)\\*")
	return regex.sub(md, "[i]${italics}[/i]", true)


func _convert_strikethrough(md: String) -> String:
	var regex := RegEx.new()
	regex.compile("~~(?<strikethrough>[^~\\n]+?)~~")
	return regex.sub(md, "[s]${strikethrough}[/s]", true)


func _convert_inline_code(md: String) -> String:
	var regex := RegEx.new()
	regex.compile("`(?<inline_code>[^`\\n]+?)`")
	return regex.sub(md, "[bgcolor=#343942][code]${inline_code}[/code][/bgcolor]", true)


func _convert_image(md: String) -> String:
	var regex := RegEx.new()
	regex.compile("!\\[(?<alt_text>.+?)\\]\\((?<path>.+?)\\)")
	return regex.sub(md, "[img]${path}[/img]", true)


func _convert_link(md: String) -> String:
	var regex := RegEx.new()
	regex.compile("\\[(?<text>.+?)\\]\\((?<path>.+?)\\)")
	return regex.sub(md, "[color=#2c77e3][url=${path}]${text}[/url][/color]", true)


func _convert_unordered_list(md: String) -> String:
	var regex := RegEx.new()
	regex.compile("[+*-]\\s(?<item>.*)")
	return regex.sub(md, "[ul]${item}[/ul]", true)


func _convert_indentation(md: String) -> String:
	var regex := RegEx.new()
	regex.compile("\\t(?<text>[^\\t\\n].*)")
	return regex.sub(md, "[indent]${text}[/indent]", true)


func _convert_styling(md: String) -> String:
	md = _convert_bolded(md)
	md = _convert_italics(md)
	md = _convert_strikethrough(md)
	md = _convert_inline_code(md)
	return md

#################################################
#_______________ SIGNAL CALLBACKS ______________#
#################################################

#_______________________________________________#
#__________________ INTERNAL ___________________#
#_______________________________________________#

#_______________________________________________#
#__________________ EXTERNAL ___________________#
#_______________________________________________#


