@tool
extends Button

@export var prompt_field: TextEdit
@export var generator_name: String = "dalle-3"

func _ready() -> void:
	$".".pressed.connect(_pressed)

func _pressed() -> void:
	if prompt_field.text == "":
		return
	var b = Scheduler.temporarily_disable_button($".")
	prompt_field.text = await GaxosContentGeneration.improve_prompt(prompt_field.text, generator_name)
	Scheduler.enable_button(b)
