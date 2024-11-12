@tool
extends VBoxContainer

var _sortBy = "";
var _sortByDirection = "";

var selectedId = -1

func _ready() -> void:
	$VBoxContainer/RefreshButton.pressed.connect(refresh)
	$VBoxContainer/ScrollContainer/VBoxContainer/Header/IdHeader.pressed.connect(func (): _setSortBy("id"))
	$VBoxContainer/ScrollContainer/VBoxContainer/Header/CreatedHeader.pressed.connect(func (): _setSortBy("created_at"))
	refresh()

func _setSortBy(field: String) -> void:
	if _sortBy == field:
		if _sortByDirection == "desc":
			_sortByDirection = "asc"
		else:
			_sortByDirection = "desc"
	else:
		_sortBy = field
		_sortByDirection = "desc"
	self.refresh()

func refresh() -> void:
	$"VBoxContainer/Details Container".hide()
	
	$VBoxContainer/RefreshButton.disabled = true
	for n in $VBoxContainer/ScrollContainer/VBoxContainer/RequestsContainer.get_children():
		$VBoxContainer/ScrollContainer/VBoxContainer/RequestsContainer.remove_child(n)
		n.queue_free()
	var requests = await GaxosContentGeneration.get_requests(100, 0, _sortBy, _sortByDirection == "desc", "godot_editor")
	$VBoxContainer/RefreshButton.disabled = false
	for request in requests:
		var requestRow = load("res://addons/gaxos-content-generation/window/request_row.tscn").instantiate()
		requestRow.initialize(request, func (): _showDetails(request))
		$VBoxContainer/ScrollContainer/VBoxContainer/RequestsContainer.add_child(requestRow)
		if selectedId == request["id"]:
			_showDetails(request)

func _showDetails(request: Dictionary) -> void:
	selectedId = request["id"]
	$"VBoxContainer/Details Container".showRequest(request, refresh)
