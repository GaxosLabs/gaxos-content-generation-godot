@tool
extends GenerateScrollContainer

func _ready() -> void:
	$"VBoxContainer/Prompt".text_changed.connect(_refresh_code)
	$"VBoxContainer/Prompt Missing Error Label".hide()
	super()

func _generate() -> void:
	$"VBoxContainer/Prompt Missing Error Label".hide()
	if $VBoxContainer/Prompt.text == "":
		$"VBoxContainer/Prompt Missing Error Label".show()
		return
	super()
	
func _request_generation():
	await GaxosContentGeneration.request_generation(
		"stability-text-to-image",
		{
			engine_id = "stable-diffusion-v1-6",
			text_prompts = [{
				text = $VBoxContainer/Prompt.text,
				weight = 1
			}],
			cfg_scale = 7,
			clip_guidance_preset= "NONE",
			samples = 4,
			steps = 30,
			width = 512,
			height = 512
		},
		{},
		{
			player_id = "godot_editor"
		}
	)
	
func _get_code() -> String:
	return "await GaxosContentGeneration.request_generation(\n" + \
	"\"stability-text-to-image\",\n" + \
	"{\n" + \
	"	engine_id = \"stable-diffusion-v1-6\",\n" + \
	"	text_prompts = [{\n" + \
	"		text = \"" + $VBoxContainer/Prompt.text + "\",\n" + \
	"		weight = 1\n" + \
	"	}],\n" + \
	"	cfg_scale = 7,\n" + \
	"	clip_guidance_preset= \"None\",\n" + \
	"	samples = 4,\n" + \
	"	steps = 30,\n" + \
	"	width = 512,\n" + \
	"	height = 512\n" + \
	"},\n" + \
	"{},\n" + \
	"{\n" + \
	"	player_id = \"godot_editor\"\n" + \
	"})"
