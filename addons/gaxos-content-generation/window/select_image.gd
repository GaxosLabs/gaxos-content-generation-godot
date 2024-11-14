@tool
extends HBoxContainer
class_name SelectImage

func _get(property):
	if property == "label":
		return $Label.text
	elif property == "button_label":
		return $Button.text

func _set(property, value):
	if property == "label":
		$Label.text = value
		return true
	elif property == "button_label":
		$Button.text = value
		return true
	return false

func _get_property_list():
	return [
		{ "name": "label", "type": TYPE_STRING },
		{ "name": "button_label", "type": TYPE_STRING }
	]
	
func _ready() -> void:
	$Button.pressed.connect(_select_image)
	$FileDialog.file_selected.connect(_image_selected)
	$FileDialog.add_filter("*.png")
	
func _select_image() -> void:
	$FileDialog.show()

var image: Image
func _image_selected(path: String) -> void:
	if !path:
		return
		
	image = Image.new()
	var error = image.load(path)
	if error != OK:
		push_error("Couldn't load the image.")

	var texture = ImageTexture.create_from_image(image)
	$Image.texture = texture
