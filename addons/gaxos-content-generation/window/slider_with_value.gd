@tool
extends HBoxContainer
	
func _ready() -> void:
	$HSlider.value_changed.connect(_refresh_text)
	_refresh_text($HSlider.value)

func _refresh_text(v: float) -> void:
	$TextEdit.text = "%f" % v
