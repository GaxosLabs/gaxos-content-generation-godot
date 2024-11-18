@tool
extends GenerateScrollContainer

func _ready() -> void:
	$"VBoxContainer/Image Missing Error Label".hide()
	$"VBoxContainer/Mask Missing Error Label".hide()
	$"VBoxContainer/Prompt".text_changed.connect(_refresh_code)
	$"VBoxContainer/Prompt Missing Error Label".hide()
	
	$VBoxContainer/Model.item_selected.connect(_model_changed)
	$VBoxContainer/Resolution.item_selected.connect(func (v): _refresh_code())
	$VBoxContainer/Quality.item_selected.connect(func (v): _refresh_code())
	$VBoxContainer/Style.item_selected.connect(func (v): _refresh_code())
	$VBoxContainer/NSamples/HSlider.value_changed.connect(func (v): _refresh_code())

	$VBoxContainer/ImprovePromptCheckbox.pressed.connect(_refresh_code)
	_model_changed($VBoxContainer/Model.selected)
	
	$VBoxContainer/ReplaceColor.color_changed.connect(func (v): _refresh_code())
	$"VBoxContainer/ReplaceColorDelta/HSlider".value_changed.connect(func (v): _refresh_code())
	$"VBoxContainer/Make color transparent".pressed.connect(_make_color_transparent_changed)
	_make_color_transparent_changed()
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

func _make_color_transparent_changed() -> void:
	if $"VBoxContainer/Make color transparent".button_pressed:
		$VBoxContainer/ReplaceColor.show()
		$VBoxContainer/ReplaceColorDelta.show()
	else:
		$VBoxContainer/ReplaceColor.hide()
		$VBoxContainer/ReplaceColorDelta.hide()
	_refresh_code()

func _generate() -> void:
	$"VBoxContainer/Image Missing Error Label".hide()
	$"VBoxContainer/Mask Missing Error Label".hide()
	$"VBoxContainer/Prompt Missing Error Label".hide()
	if !$VBoxContainer/SelectImage.image:
		$"VBoxContainer/Image Missing Error Label".show()
		return
	if !$VBoxContainer/SelectMask.image:
		$"VBoxContainer/Mask Missing Error Label".show()
		return
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
			image= Marshalls.raw_to_base64($VBoxContainer/SelectImage.image.save_png_to_buffer()),
			mask= Marshalls.raw_to_base64($VBoxContainer/SelectMask.image.save_png_to_buffer()),
		}
	else: 
		parameters = {
			prompt = $VBoxContainer/Prompt.text,
			model = "dall-e-3",
			n= $VBoxContainer/NSamples/HSlider.value,
			quality= $VBoxContainer/Quality.text.to_lower(),
			size= $VBoxContainer/Resolution.text,
			style= $VBoxContainer/Style.text.to_lower(),
			image= Marshalls.raw_to_base64($VBoxContainer/SelectImage.image.save_png_to_buffer()),
			mask= Marshalls.raw_to_base64($VBoxContainer/SelectMask.image.save_png_to_buffer()),
		}
		
	var options;
	if $"VBoxContainer/Make color transparent".button_pressed:
		options = {
			transparent_color = "\"%s\"" % $VBoxContainer/ReplaceColor.color.to_html(),
			transparent_color_replace_delta = $"VBoxContainer/ReplaceColorDelta/HSlider".value,
			improve_prompt = $VBoxContainer/ImprovePromptCheckbox.button_pressed
		}
	else:
		options = {
			improve_prompt = $VBoxContainer/ImprovePromptCheckbox.button_pressed
		}
	await GaxosContentGeneration.request_generation(
		"dall-e-inpainting",
		parameters,
		options,
		{
			player_id = "godot_editor"
		}
	)
	
func _get_code() -> String:
	var parameters;
	if $VBoxContainer/Model.selected == 0:
		parameters = "{\n" + \
			"	prompt = \"" + $VBoxContainer/Prompt.text + "\",\n" + \
			"	model = \"dall-e-2\",\n" + \
			"	n = " + str($VBoxContainer/NSamples/HSlider.value) + ",\n" + \
			"	size = \"" + $VBoxContainer/Resolution.text + "\",\n" + \
			"	image = \"<base 64 image>\",\n" + \
			"	mask = \"<base 64 mask>\",\n" + \
			"},\n"	
	else: 
		parameters = "{\n" + \
			"	prompt = \"" + $VBoxContainer/Prompt.text + "\",\n" + \
			"	model = \"dall-e-3\",\n" + \
			"	n = " + str($VBoxContainer/NSamples/HSlider.value) + ",\n" + \
			"	quality = \"" + $VBoxContainer/Quality.text.to_lower() + "\",\n" + \
			"	size = \"" + $VBoxContainer/Resolution.text + "\",\n" + \
			"	style = \"" + $VBoxContainer/Style.text.to_lower() + "\",\n" + \
			"	image = \"<base 64 image>\",\n" + \
			"	mask = \"<base 64 mask>\",\n" + \
			"},\n"
		
	return "await GaxosContentGeneration.request_generation(\n" + \
	"\"dall-e-text-to-image\",\n" + \
	parameters + \
	"{\n" + \
	"	improve_prompt = " + ("true" if $VBoxContainer/ImprovePromptCheckbox.button_pressed else "false") + ",\n" + \
	"},\n" + \
	"{\n" + \
	"	player_id = \"godot_editor\"\n" + \
	"})"
