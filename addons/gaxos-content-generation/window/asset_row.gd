@tool
extends VBoxContainer

var asset: Dictionary

func initialize(asset: Dictionary) -> void:
	self.asset = asset

var disabledButton

func _ready() -> void:
	$TextureButton.texture_normal = null
	$HTTPRequest.request_completed.connect(self._http_request_completed)
	if "url" in asset && asset["url"] != "":
		var error = $HTTPRequest.request(asset["url"])
		if error != OK:
			push_error("An error occurred in the HTTP request.")
	
		disabledButton = Scheduler.temporarily_disable_button($Button)
		$Button.pressed.connect(_save)
		$FileDialog.file_selected.connect(_save_to_file)
		$FileDialog.add_filter("*.png")
		
		$TextureButton.pressed.connect(func (): OS.shell_open(asset["url"]))
	

var _image: Image = null
func _http_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray):
	if result != HTTPRequest.RESULT_SUCCESS:
		push_error("Image couldn't be downloaded. Try a different image.")

	_image = Image.new()
	var error = _image.load_png_from_buffer(body)
	if error != OK:
		push_error("Couldn't load the image.")

	var texture = ImageTexture.create_from_image(_image)
	$TextureButton.texture_normal = texture
	Scheduler.enable_button(disabledButton)
	
func _save():
	$FileDialog.show()

func _save_to_file(path: String):
	_image.save_png(path)
