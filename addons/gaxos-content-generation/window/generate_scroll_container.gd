@tool
extends ScrollContainer
class_name GenerateScrollContainer
	
signal generated

func _ready() -> void:
	$"VBoxContainer/Generate Button".pressed.connect(_generate)
	_refresh_code()
		
func _generate() -> void:
	$"VBoxContainer/Generate Button".disabled = true
	await self._request_generation()
	generated.emit()
	$"VBoxContainer/Generate Button".disabled = false
	
func _refresh_code() -> void:
	$VBoxContainer/Code.text = self._get_code()
	
func _request_generation():
	return
	
func _get_code() -> String:
	return ""
