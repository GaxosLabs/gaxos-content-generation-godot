@tool
extends VBoxContainer

var _request: Dictionary
func _ready() -> void:
	$ScrollContainer/VBoxContainer/DeleteButton.pressed.connect(_deleteRequest)
	$Refresh.pressed.connect(_refreshThis)

var _refresh: Callable
func showRequest(request: Dictionary, refresh: Callable) -> void:
	_request = request
	_refresh = refresh
	$HBoxContainer/GeneratorLabel.text = request["generator"]
	if "stability" in request["generator"]:
		$HBoxContainer/Icon.texture = load("res://addons/gaxos-content-generation/window/Stability AI.png")
	elif "dall-e" in request["generator"]:
		$HBoxContainer/Icon.texture = load("res://addons/gaxos-content-generation/window/Dall-E.png")
	elif "meshy" in request["generator"]:
		$HBoxContainer/Icon.texture = load("res://addons/gaxos-content-generation/window/Meshy.png")
	elif "gaxos" in request["generator"]:
		$HBoxContainer/Icon.texture = load("res://addons/gaxos-content-generation/window/Gaxos Labs AI.png")
	elif "elevenlabs" in request["generator"]:
		$HBoxContainer/Icon.texture = load("res://addons/gaxos-content-generation/window/Eleven Labs.png")
	
	$ScrollContainer/VBoxContainer/HBoxContainer/StatusLabel.text = request["status"]
	if request["status"] != "PENDING":
		$Refresh.hide()
	else:
		$Refresh.show()

	if request["status"] == "FAILED":
		$ErrorDetails.show()
		$ErrorDetails/Error.text = request["generator_error"]["message"] if request["generator_error"]["message"] else JSON.stringify(request["generator_error"])
	else:
		$ErrorDetails.hide()
		
	$ScrollContainer/VBoxContainer/GeneratorParameters.text = str(request["generator_parameters"])

	for n in $ScrollContainer/VBoxContainer/AssetsContainer.get_children():
		$ScrollContainer/VBoxContainer/AssetsContainer.remove_child(n)
		n.queue_free()
	var assets = request["assets"]
	for asset in assets:
		var assetRow = load("res://addons/gaxos-content-generation/window/asset_row.tscn").instantiate()
		assetRow.initialize(asset)
		$ScrollContainer/VBoxContainer/AssetsContainer.add_child(assetRow)

	self.show()

func _refreshThis() -> void:
	var b = Scheduler.temporarily_disable_button($Refresh)
	var updatedRequest = await GaxosContentGeneration.get_request(str(_request["id"]))
	Scheduler.enable_button(b)
	self.showRequest(updatedRequest, self._refresh)

func _deleteRequest() -> void:
	var b = Scheduler.temporarily_disable_button($ScrollContainer/VBoxContainer/DeleteButton)
	await GaxosContentGeneration.delete_request(str(_request["id"]))
	Scheduler.enable_button(b)
	_refresh.call()
