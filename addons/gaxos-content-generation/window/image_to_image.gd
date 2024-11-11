@tool
extends GenerateScrollContainer

func _ready() -> void:
	$"VBoxContainer/Prompt".text_changed.connect(_refresh_code)
	$"VBoxContainer/Prompt Missing Error Label".hide()
	$"VBoxContainer/Image Missing Error Label".hide()
	super()

func _generate() -> void:
	$"VBoxContainer/Prompt Missing Error Label".hide()
	$"VBoxContainer/Image Missing Error Label".hide()
	if $VBoxContainer/Prompt.text == "":
		$"VBoxContainer/Prompt Missing Error Label".show()
		return
	if !$VBoxContainer/SelectImage.image:
		$"VBoxContainer/Image Missing Error Label".show()
		return
	super()
	
func _request_generation():
	await GaxosContentGeneration.request_generation(
		"stability-image-to-image",
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
			height = 512,
			init_image = Marshalls.raw_to_base64($VBoxContainer/SelectImage.image.save_png_to_buffer()),
			init_image_mode = "IMAGE_STRENGTH",
			image_strength = .35			
		},
		{},
		{
			player_id = "godot_editor"
		}
	)
	
func _get_code() -> String:
	return "await GaxosContentGeneration.request_generation(\n" + \
	"\"stability-image-to-image\",\n" + \
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
	"	init_image = \"<base 64 image>\",\n" + \
	"	init_image_mode = \"IMAGE_STRENGTH\",\n" + \
	"	image_strength = .35\n" + \
	"},\n" + \
	"{},\n" + \
	"{\n" + \
	"	player_id = \"godot_editor\"\n" + \
	"})"
