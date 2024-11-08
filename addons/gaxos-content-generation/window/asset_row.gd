@tool
extends VBoxContainer

var asset: Dictionary

func initialize(asset: Dictionary) -> void:
	self.asset = asset

func _ready() -> void:
	$TextureRect.texture = null
	$HTTPRequest.request_completed.connect(self._http_request_completed)
	var error = $HTTPRequest.request(asset["url"])
	if error != OK:
		push_error("An error occurred in the HTTP request.")
	
	$Button.disabled = true
	$Button.pressed.connect(_save)
	$FileDialog.file_selected.connect(_save_to_file)
	$FileDialog.add_filter("*.png")
	

var _image: Image = null
func _http_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray):
	if result != HTTPRequest.RESULT_SUCCESS:
		push_error("Image couldn't be downloaded. Try a different image.")

	_image = Image.new()
	var error = _image.load_png_from_buffer(body)
	if error != OK:
		push_error("Couldn't load the image.")

	var texture = ImageTexture.create_from_image(_image)
	$TextureRect.texture = texture
	$Button.disabled = false	
	
func _save():
	$FileDialog.show()

func _save_to_file(path: String):
	_image.save_png(path)
