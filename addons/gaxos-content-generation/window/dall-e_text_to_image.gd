@tool
extends GenerateScrollContainer

func _ready() -> void:
	$"VBoxContainer/Prompt".text_changed.connect(_refresh_code)
	$"VBoxContainer/Prompt Missing Error Label".hide()
	
	$VBoxContainer/Model.item_selected.connect(_model_changed)
	$VBoxContainer/Resolution.item_selected.connect(func (v): _refresh_code())
	$VBoxContainer/Quality.item_selected.connect(func (v): _refresh_code())
	$VBoxContainer/Style.item_selected.connect(func (v): _refresh_code())
	$VBoxContainer/NSamples/HSlider.value_changed.connect(func (v): _refresh_code())

	$VBoxContainer/ImprovePromptCheckbox.pressed.connect(_refresh_code)
	_model_changed($VBoxContainer/Model.selected)
	super()

func _model_changed(v) -> void:
	if(v==0):
		$VBoxContainer/NSamples/HSlider.max_value = 10
		$VBoxContainer/StyleLabel.hide()
		$VBoxContainer/Style.hide()
		$VBoxContainer/Resolution.clear()
		$VBoxContainer/Resolution.add_item("256x256", 0)
		$VBoxContainer/Resolution.add_item("512x512", 1)
		$VBoxContainer/Resolution.add_item("1024x1024", 2)
		$VBoxContainer/Resolution.select(1)
		$VBoxContainer/QualityLabel.hide()
		$VBoxContainer/Quality.hide()
	else:
		$VBoxContainer/NSamples/HSlider.value = 1
		$VBoxContainer/NSamples/HSlider.max_value = 1
		$VBoxContainer/StyleLabel.show()
		$VBoxContainer/Style.show()
		$VBoxContainer/Resolution.clear()
		$VBoxContainer/Resolution.add_item("1024x1024", 0)
		$VBoxContainer/Resolution.add_item("1792x1024", 1)
		$VBoxContainer/Resolution.add_item("1024x1792", 2)
		$VBoxContainer/Resolution.select(0)
		$VBoxContainer/QualityLabel.show()
		$VBoxContainer/Quality.show()
	_refresh_code()

func _generate() -> void:
	$"VBoxContainer/Prompt Missing Error Label".hide()
	if $VBoxContainer/Prompt.text == "":
		$"VBoxContainer/Prompt Missing Error Label".show()
		return
	super()
	
func _request_generation():
	var parameters;
	if $VBoxContainer/Model.selected == 0:
		parameters = {
			prompt = $VBoxContainer/Prompt.text,
			model = "dall-e-2",
			n= $VBoxContainer/NSamples/HSlider.value,
			size= $VBoxContainer/Resolution.text,
		}
	else: 
		parameters = {
			prompt = $VBoxContainer/Prompt.text,
			model = "dall-e-3",
			n= $VBoxContainer/NSamples/HSlider.value,
			quality= $VBoxContainer/Quality.text.to_lower(),
			size= $VBoxContainer/Resolution.text,
			style= $VBoxContainer/Style.text.to_lower(),
		}
	await GaxosContentGeneration.request_generation(
		"dall-e-text-to-image",
		parameters,
		{
			improve_prompt = $VBoxContainer/ImprovePromptCheckbox.button_pressed
		},
		{
			player_id = "godot_editor"
		}
	)
	
func _get_code() -> String:
	return "await GaxosContentGeneration.request_generation(\n" + \
	"\"dall-e-text-to-image\",\n" + \
	"{\n" + \
	"	prompt = \"" + $VBoxContainer/Prompt.text + "\",\n" + \
	"	model = \"" + ("dall-e-2" if $VBoxContainer/Model.selected == 0 else "dall-e-3") + "\",\n" + \
	"	n = " + str($VBoxContainer/NSamples/HSlider.value) + ",\n" + \
	"	quality = \"" + $VBoxContainer/Quality.text.to_lower() + "\",\n" + \
	"	size = \"" + $VBoxContainer/Resolution.text + "\",\n" + \
	"	style = \"" + $VBoxContainer/Style.text.to_lower() + "\",\n" + \
	"},\n" + \
	"{\n" + \
	"	improve_prompt = " + ("true" if $VBoxContainer/ImprovePromptCheckbox.button_pressed else "false") + ",\n" + \
	"},\n" + \
	"{\n" + \
	"	player_id = \"godot_editor\"\n" + \
	"})"
