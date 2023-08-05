# Godot style guide


This is an unofficial style guide for [Godot](https://godotengine.org) - a free,
libre and open-source game engine.


## Common naming conventions

- `snake_case` is **like_this**.

- `PascalCase` is **LikeThis**.

- `CONSTANT_CASE` is **LIKE_THIS**.


## Code order
- Check `/templates` for code templates that may help you be more organized
 
```gdscript
01. @tool
02. class_name
03. extends
04. ## docstring

05. signals
06. enums
07. constants
08. @export variables
09. public variables
10. private variables
11. @onready variables

12. optional built-in virtual _init method
13. optional built-in virtual _enter_tree() method
14. built-in virtual _ready method
15. remaining built-in virtual methods
16. public methods
17. private methods
18. subclasses
```


## Class name

- Use `PascalCase`
```gdscript
class_name MyNode
extends Node
```


## Signals
- Use `snake_case`
- Always in past tense
```gdscript
signal button_clicked
signal door_opened
```

- Use parentheses if the signals have parameters
```gdscript
signal points_updated(before, after)
```

- Append `_started` or `_finished` if the signal corresponds to the beginning or the end of an action
```gdscript
signal transition_started(animation)
signal transition_finished
```


## Enums
- Use `PascalCase` for the enum's **Name**
- Use `CONSTANT_CASE` for the enum's **KEYS**
```gdscript
# Unnamed enum
enum {TILE_BRICK, TILE_FLOOR, TILE_CEILING,}

# Named enum
enum State {
    IDLE,
    WALK,
    RUN,
    JUMP,
}
```


## Constants
- Use `CONSTANT_CASE` or `PascalCase`
```gdscript
const PI := 3.14
const MAX_SPEED := 200
```

```gdscript
# Containing a script resource
const MyScript = preload("res://my_script.gd")
```


## Exported variables
- Use `snake_case` in most cases
```gdscript
@export var speed := 50.0
@export_range(0.1, 1.0, 0.1) var scale: float
```
  

## Public variables / functions
- Use `snake_case`
```gdscript
var anything
var speed: float
var name := "John"
var another_name: String = "Mike"
```

```gdscript
func do_something(parameter: int) -> void:
    return
```


## Private variables / functions
- Use `snake_case`
- Prepend a single underscore `_name`
```gdscript
var _counter: int
var _: float
var name := "John"
var another_name: String = "Mike"
```

```gdscript
func _do_something_exclusive(parameter: int) -> void:
    return
```


## Onready variables
- Use `snake_case`
```gdscript
@onready var sword := get_node("Arm/Sword")
@onready var gun := $Arm/Gun
@onready var shield := %Shield 
```


# Others

## Comments

- Begin comments with an uppercase letter, unless you are referencing a function
  or a variable. Do not end them with a period, unless the comment has several
  sentences.

- Comments should have a space after the `#` symbol, and should be indented as
  usual.

Example:

```gdscript
# Outputs "Hello world!" to console
print("Hello world!")
```


## Booleans


# Resources

___

# Contributing to this document

Contributions are welcome, feel free to discuss on the
[issues](https://github.com/Calinou/godot-style-guide/issues).

# License

Copyright (c) 2015-2017 Hugo Locurcio and contributors

CC0 1.0 Universal, see [LICENSE.md](LICENSE.md).