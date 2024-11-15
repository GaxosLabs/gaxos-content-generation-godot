@tool
extends HBoxContainer
	
func _ready() -> void:
	$HSlider.value_changed.connect(_refresh_text)
	$TextEdit.text_changed.connect(_text_changed)
	_refresh_text($HSlider.value)

func _text_changed(v: String) -> void:
	print(v)
	
@export var numberOfDecimals: int = 0

func _refresh_text(v: float) -> void:
	$TextEdit.text = "%.*f" % [numberOfDecimals, v]
