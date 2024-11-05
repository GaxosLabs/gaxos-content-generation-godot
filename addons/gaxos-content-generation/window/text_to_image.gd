@tool
extends ScrollContainer

func _ready() -> void:
	$"VBoxContainer/Generate Button".pressed.connect(_generate)
	$"VBoxContainer/Error Label".hide()
	$"VBoxContainer/Prompt".text_changed.connect(_refresh_code)
	_refresh_code()
		
func _generate() -> void:
	if $VBoxContainer/Prompt.text == "":
		$"VBoxContainer/Error Label".show()
		return
	$"VBoxContainer/Error Label".hide()
	$"VBoxContainer/Generate Button".disabled = true
	await GaxosContentGeneration.request_generation(
		"stability-text-to-image",
		{
			text_prompts = {
				text = $VBoxContainer/Prompt.text,
				weight = 1
			},
			width = 512,
			height = 512
		},
		{},
		{
			player_id = "godot_editor"
		}
	)
	$"VBoxContainer/Generate Button".disabled = false
	
func _refresh_code() -> void:
	$VBoxContainer/Code.text = "await GaxosContentGeneration.request_generation(\n" + \
		"\"stability-text-to-image\",\n" + \
		"{\n" + \
		"	text_prompts = {\n" + \
		"		text = \"" + $VBoxContainer/Prompt.text + "\",\n" + \
		"		weight = 1\n" + \
		"	},\n" + \
		"	width = 512,\n" + \
		"	height = 512\n" + \
		"},\n" + \
		"{},\n" + \
		"{\n" + \
		"	player_id = \"godot_editor\"\n" + \
		"})"
