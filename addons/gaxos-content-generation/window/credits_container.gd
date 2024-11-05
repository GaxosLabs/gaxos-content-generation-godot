@tool
extends HBoxContainer

func _ready() -> void:
	$"Refresh".pressed.connect(_refresh)
	_refresh()

func _refresh() -> void:
	$"Refresh".disabled = true
	$"Credits Text Box".text = ""
	var stats = await GaxosContentGeneration.get_stats()
	$"Credits Text Box".text = str(stats["credits"]["total"] - stats["credits"]["used"]) + " / " + str(stats["credits"]["total"])
	$"Refresh".disabled = false
