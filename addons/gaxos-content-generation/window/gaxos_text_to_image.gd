@tool
extends GenerateScrollContainer

func _ready() -> void:
	$"VBoxContainer/Prompt".text_changed.connect(_refresh_code)
	$"VBoxContainer/Prompt Missing Error Label".hide()
	$"VBoxContainer/NegativePrompt".text_changed.connect(_refresh_code)
	$VBoxContainer/Checkpoint.text_changed.connect(_refresh_code)
	$VBoxContainer/NSamples/HSlider.value_changed.connect(func (v): _refresh_code())
	$"VBoxContainer/Send seed".pressed.connect(_refresh_seed_slider)
	$VBoxContainer/Seed/HSlider.value_changed.connect(func (v): _refresh_code())
	_refresh_seed_slider()
	$VBoxContainer/Steps/HSlider.value_changed.connect(func (v): _refresh_code())
	$VBoxContainer/CfgScale/HSlider.value_changed.connect(func (v): _refresh_code())
	$VBoxContainer/Sampler.text_changed.connect(_refresh_code)
	$VBoxContainer/Scheduler.text_changed.connect(_refresh_code)
	$VBoxContainer/Denoise/HSlider.value_changed.connect(func (v): _refresh_code())
	$VBoxContainer/Loras.text_changed.connect(_refresh_code)
	$VBoxContainer/Width/HSlider.value_changed.connect(func (v): _refresh_code())
	$VBoxContainer/Height/HSlider.value_changed.connect(func (v): _refresh_code())
	super()

func _refresh_seed_slider():
	$VBoxContainer/Seed/HSlider.editable = $"VBoxContainer/Send seed".button_pressed
	_refresh_code()

func _generate() -> void:
	$"VBoxContainer/Prompt Missing Error Label".hide()
	if $VBoxContainer/Prompt.text == "":
		$"VBoxContainer/Prompt Missing Error Label".show()
		return
	super()
	
func _request_generation():
	await GaxosContentGeneration.request_generation(
		"gaxos-text-to-image",
		{
			prompt = $VBoxContainer/Prompt.text,
			negative_prompt = $VBoxContainer/NegativePrompt.text,

			checkpoint = $VBoxContainer/Checkpoint.text,
			n_samples = $VBoxContainer/NSamples/HSlider.value,
			seed= $VBoxContainer/Seed/HSlider.value if $"VBoxContainer/Send seed".button_pressed else null,
			steps = $VBoxContainer/Steps/HSlider.value,
			cfg = $VBoxContainer/CfgScale/HSlider.value,
			sampler_name = $VBoxContainer/Sampler.text,
			scheduler = $VBoxContainer/Scheduler.text,
			denoise = $VBoxContainer/Denoise/HSlider.value,
			loras = $VBoxContainer/Loras.text,
			width = $VBoxContainer/Width/HSlider.value,
			height= $VBoxContainer/Height/HSlider.value
		},
		{},
		{
			player_id = "godot_editor"
		}
	)
	
func _get_code() -> String:
	return "await GaxosContentGeneration.request_generation(\n" + \
	"\"gaxos-text-to-image\",\n" + \
	"{\n" + \
	"	prompt = \"" + $VBoxContainer/Prompt.text + "\",\n" + \
	"	negative_prompt = \"" + $VBoxContainer/NegativePrompt.text + "\",\n" + \
	"	checkpoint = \"" + $VBoxContainer/Checkpoint.text + "\",\n" + \
	"	n_samples = " + str($VBoxContainer/NSamples/HSlider.value) + ",\n" + \
	"	seed= " + (str($VBoxContainer/Seed/HSlider.value) if $"VBoxContainer/Send seed".button_pressed else "") + ",\n" + \
	"	steps = " + str($VBoxContainer/Steps/HSlider.value) + ",\n" + \
	"	cfg = " + str($VBoxContainer/CfgScale/HSlider.value) + ",\n" + \
	"	sampler_name = \"" + $VBoxContainer/Sampler.text + "\",\n" + \
	"	scheduler = \"" + $VBoxContainer/Scheduler.text + "\",\n" + \
	"	denoise = " + str($VBoxContainer/Denoise/HSlider.value) + ",\n" + \
	"	loras = \"" + $VBoxContainer/Loras.text + "\",\n" + \
	"	width = " + str($VBoxContainer/Width/HSlider.value) + ",\n" + \
	"	height= " + str($VBoxContainer/Height/HSlider.value) + ",\n" + \
	"},\n" + \
	"{},\n" + \
	"{\n" + \
	"	player_id = \"godot_editor\"\n" + \
	"})"
